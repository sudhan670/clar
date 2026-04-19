class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show]
  before_action :set_room,    only: [:new, :show]

  def index
  @bookings = current_user.bookings.includes(:room)

  @invitations = current_user.meeting_participants
                              .pending
                              .includes(booking: [:room, :user])
                              .order('bookings.start_time')
end

  def new
    @booking = Booking.new
    @rooms   = Room.all
    @users   = User.where.not(id: current_user.id)
  end

  def show
    @meeting_participants = @booking.meeting_participants.includes(:user)
  end

  def create
    @booking      = Booking.new(booking_params)
    @booking.user = current_user

    # FIX 1: The form submits duration_in_hours, not end_time.
    # Compute end_time here before validation runs.
    if @booking.start_time.present? && params[:booking][:duration_in_hours].present?
      duration = params[:booking][:duration_in_hours].to_f
      @booking.end_time = @booking.start_time + duration.hours
    end

    if @booking.save
      if params[:booking][:participant_ids].present?
        params[:booking][:participant_ids].reject(&:blank?).each do |user_id|
          MeetingParticipant.create(
            user_id: user_id,
            booking: @booking,
            status:  'pending'
          )
        end
      end

      mp = MeetingParticipant.find_or_initialize_by(user: current_user, booking: @booking)
      mp.status = 'accepted'
      mp.save!

      redirect_to room_booking_path(@booking.room, @booking),
                  notice: 'Booking created successfully.'
    else
      @rooms = Room.all
      @users = User.where.not(id: current_user.id)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = if params[:room_id]
              Room.find_by(id: params[:room_id])
            elsif @booking
              @booking.room
            end

    redirect_to rooms_path, alert: 'Room not found.' and return unless @room
  end

  def set_booking
    @booking = current_user.bookings.find_by(id: params[:id])
    redirect_to bookings_path, alert: 'Booking not found.' and return unless @booking
  end

  def booking_params
    # FIX 2: Permit description so it isn't stripped by strong parameters.
    # duration_in_hours is intentionally NOT permitted here — it's not a DB
    # column, we handle it manually above to derive end_time instead.
    params.require(:booking).permit(:room_id, :start_time, :end_time, :description, participant_ids: [])
  end
end