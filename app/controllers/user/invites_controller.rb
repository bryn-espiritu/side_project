class User::InvitesController < ApplicationController
  before_action :authenticate_user!

  def index
    @invite_link = invite_link
    @qrcode = qr_code_download
  end

  def qr_code_download
    RQRCode::QRCode.new(invite_link).as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 10,
      standalone: true,
      use_path: true
    ).html_safe
  end

  def invite_link
    "#{request.base_url}/users/sign_up?#{ { promoter: current_user.email }.to_query }"
  end
end
