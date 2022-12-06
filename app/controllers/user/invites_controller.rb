class User::InvitesController < ApplicationController
  require 'rqrcode'
  def index
    @qrcode = qr_code_download
    @invite_link = invite_link
  end


  def qr_code_download
    qrcode = RQRCode::QRCode.new("client.com:3000/users/sign_up?promoter=#{current_user.email}")

    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 10,
      standalone: true,
      use_path: true
    ).html_safe
  end

  def invite_link
    "#{request.base_url}/users/sign_up?promoter=#{current_user.email}"
  end
end
