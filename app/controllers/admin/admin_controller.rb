class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  
  def dashboard
    @rooms = Room.all
    @users = User.where(role: 'employee')

    @today_bookings = Booking
      .includes(:room)
      .where(start_time: Time.zone.today.all_day)

    @pending_invitations = MeetingParticipant
      .includes(booking: :room, user: {})
      .where(status: 'pending')
      .joins(:booking)
      .order('bookings.start_time')
  end
    
  private
  
  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end