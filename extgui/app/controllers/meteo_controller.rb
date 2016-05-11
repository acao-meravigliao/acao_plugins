class MeteoController < ApplicationController

  layout false

  def main
    iu = Rails.application.config.extgui.faye_interface_uri
    @faye_interface_uri = iu.kind_of?(Proc) ? instance_exec(&iu) : iu

    iu = Rails.application.config.extgui.faye_source_uri
    @faye_source_uri = iu.kind_of?(Proc) ? instance_exec(&iu) : iu
  end

  def metar
    main
  end
end
