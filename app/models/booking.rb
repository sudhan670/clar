class Booking < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :room
  has_many :meeting_participants, dependent: :destroy
  has_many :participants, through: :meeting_participants, source: :user

  # Enums
  enum :status, {
    pending:   0,
    confirmed: 1,
    canceled:  2,
    rejected:  3
  }

  # Validations
  validates :start_time, :end_time, presence: true
  validate :start_time_must_be_at_hour_or_half_hour
  validate :end_time_must_be_at_hour_or_half_hour
  validate :booking_duration
  validate :no_overlapping_bookings
  validate :daily_booking_limit

  # Scopes
  scope :past,         -> { where('start_time < ?', Time.current) }
  scope :upcoming,     -> { where('start_time > ?', Time.current) }
  scope :current,      -> { where('start_time <= ? AND end_time >= ?', Time.current, Time.current) }
  scope :recent_first, -> { order(start_time: :desc) }
  scope :oldest_first, -> { order(start_time: :asc) }

  # FIX 1: Chain off the `confirmed` enum scope instead of a raw string so this
  # is immune to enum reordering and matches how Rails stores the value.
  # FIX 2: Exclude canceled/rejected bookings — they should not block slots.
  scope :missed, -> {
    confirmed
      .where('start_time < ?', Time.current)
      .left_joins(:meeting_participants)
      .where(
        "meeting_participants.status IS NULL OR meeting_participants.status != 'attended'"
      )
  }

  # Class Methods
  class << self
    def available_slots(room, date)
      # FIX 3: Only active (pending/confirmed) bookings block a slot.
      # Canceled or rejected bookings free the room back up.
      booked_slots = room.bookings
                         .where(status: [:pending, :confirmed])
                         .where('DATE(start_time) = ?', date)

      working_hours = (9..17).flat_map do |hour|
        [
          Time.zone.local(date.year, date.month, date.day, hour, 0),
          Time.zone.local(date.year, date.month, date.day, hour, 30)
        ]
      end

      working_hours.reject do |slot|
        booked_slots.any? { |b| slot >= b.start_time && slot < b.end_time }
      end
    end
  end

  # --- Public instance methods ---

  # FIX 4: `status == 'confirmed'` is always false for an enum attribute.
  # Rails enums expose predicate methods like `confirmed?` for this purpose.
  def missed?
    confirmed? &&
      start_time < Time.current &&
      meeting_participants.none? { |mp| mp.status == 'attended' }
  end

  def missed_reason
    read_attribute(:missed_reason) ||
      (no_participants? ? 'No participants' : nil)
  end

  def can_cancel?
    in_future? && !canceled? && start_time > (Time.current + 1.hour)
  end

  # FIX 5: Moved out from under the second `private` block — this is a
  # public method used by views/controllers to display participant status.
  def participant_status
    statuses = meeting_participants.pluck(:status)

    return :pending  if statuses.include?('pending')
    return :rejected if statuses.include?('rejected')
    return :accepted if statuses.all? { |s| s == 'accepted' }

    :unknown
  end

  private

  def no_participants?
    meeting_participants.empty?
  end

  def duration_in_hours
    return 0 if start_time.nil? || end_time.nil?

    ((end_time - start_time) / 1.hour).round(2)
  end

  def in_future?
    start_time > Time.current.in_time_zone
  end

  def start_time_must_be_at_hour_or_half_hour
    return if start_time.nil?

    unless [0, 30].include?(start_time.min)
      errors.add(:start_time, 'must be at the hour or half-hour')
    end
  end

  def end_time_must_be_at_hour_or_half_hour
    return if end_time.nil?

    unless [0, 30].include?(end_time.min)
      errors.add(:end_time, 'must be at the hour or half-hour')
    end
  end

  # FIX 6: Check end_time <= start_time first, before computing the
  # duration, so the subtraction in the duration check is always valid.
  def booking_duration
    return if start_time.nil? || end_time.nil?

    if end_time <= start_time
      errors.add(:base, 'End time must be after start time')
    elsif (end_time - start_time) > 2.hours
      errors.add(:base, 'Booking cannot be longer than 2 hours')
    end
  end

  # FIX 7: Exclude canceled/rejected bookings from the overlap check so a
  # room whose booking was canceled can immediately be re-booked.
  def no_overlapping_bookings
    return if room.nil? || start_time.nil? || end_time.nil?

    overlapping = room.bookings
                      .where(status: [:pending, :confirmed])
                      .where.not(id: id)
                      .where(
                        '(start_time < ? AND end_time > ?) OR ' \
                        '(start_time >= ? AND start_time < ?) OR ' \
                        '(end_time > ? AND end_time <= ?)',
                        end_time, start_time,
                        start_time, end_time,
                        start_time, end_time
                      )

    errors.add(:base, 'Room is already booked for the selected time') if overlapping.exists?
  end

  # FIX 8: Exclude the current record when summing existing hours so that
  # updating a booking doesn't count its own hours twice against the limit.
  def daily_booking_limit
    return if user.nil? || start_time.nil? || end_time.nil?

    existing_hours = user.bookings
                         .where.not(id: id)
                         .where('DATE(start_time) = ?', start_time.to_date)
                         .sum { |b| (b.end_time - b.start_time) / 1.hour }

    new_hours = (end_time - start_time) / 1.hour

    if existing_hours + new_hours > 2
      errors.add(:base, 'Cannot book more than 2 hours per day')
    end
  end
end