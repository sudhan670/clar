class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show]
  before_action :set_room, only: [:new, :create, :show]

  def index
    @bookings = current_user.bookings.includes(:room)
    @invitations = current_user.meeting_participants.pending.includes(booking: [:room, :user]).order('bookings.start_time')
  end
  
  def new
    @booking = @room.bookings.build
  end

  def show
    @meeting_participants = @booking.meeting_participants.includes(:user)
  end

  def create
    @booking = @room.bookings.build(booking_params)
    @booking.user = current_user

    ActiveRecord::Base.transaction do
      @booking.save!
      create_meeting_participants!
    end

    redirect_to room_booking_path(@room, @booking), notice: 'Booking was successfully created.'
  rescue ActiveRecord::RecordInvalid => e
    @booking.errors.merge!(e.record.errors) if e.record != @booking
    render :new, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    @booking.errors.add(:base, e.message)
    render :new, status: :unprocessable_entity
  end

  private

  def create_meeting_participants!
    participant_ids = Array(params[:participant_ids]).reject(&:blank?).map(&:to_i).uniq - [current_user.id]
    users_by_id = User.where(id: participant_ids).index_by(&:id)

    missing_ids = participant_ids - users_by_id.keys
    raise ActiveRecord::RecordNotFound, "Couldn't find User with IDs: #{missing_ids.join(', ')}" if missing_ids.any?

    timestamp = Time.current
    participant_rows = users_by_id.values.map do |user|
      {
        user_id: user.id,
        booking_id: @booking.id,
        status: 'pending',
        created_at: timestamp,
        updated_at: timestamp
      }
    end

    participant_rows << {
      user_id: current_user.id,
      booking_id: @booking.id,
      status: 'accepted',
      created_at: timestamp,
      updated_at: timestamp
    }

    MeetingParticipant.insert_all!(participant_rows)
  end


  def set_room
    @room = if params[:room_id]
              Room.find(params[:room_id])
            elsif @booking
              @booking.room
            end
  
    redirect_to rooms_path, alert: "Room not found" unless @room
  end
  
  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:room_id, :start_time, :end_time)
  end
end