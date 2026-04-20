class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  
  def dashboard
  @rooms = Room.all

  @today_bookings = Booking
                      .includes(:room)
                      .where(start_time: Time.zone.today.all_day)

  @users = User.where(role: 'employee')

  @pending_invitations = MeetingParticipant
                           .includes(booking: [:room, :user])
                           .where(status: 'pending')
                           .references(:bookings)
                           .order('bookings.start_time ASC')
end
  
  private
  
  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end