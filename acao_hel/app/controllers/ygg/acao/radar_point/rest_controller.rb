#
# Copyright (C) 2015-2015, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#
#/

module Ygg
module Acao

class RadarPoint::RestController < Ygg::Hel::RestController
  ar_controller_for Ygg::Acao::RadarPoint

#  view :grid do
#    empty!
#    attribute(:id) { show! }
#    attribute(:uuid) { show! }
#
#    attribute(:aircraft) do
#      show!
#      empty!
#      attribute(:registration) { show! }
#    end
#
#    attribute(:type) { show! }
#    attribute(:identifier) { show! }
#  end


  def index
    day = Time.local(params[:year], params[:month], params[:day])

    @aircrafts = TrackEntry.select(:aircraft_id).where(at: day.beginning_of_day..day.end_of_day).group(:aircraft_id).joins(:aircraft)

    respond_to do |format|
      format.json { render :json => @aircrafts.map { |x| { aircraft_id: x.aircraft_id, reg: x.aircraft.registration } } }
    end
  end

  def track
    from_time = Time.parse(params[:from]) if params[:from]
    to_time = Time.parse(params[:to]) if params[:to]

    if from_time && !to_time
      to_time = from_time.end_of_day
    elsif !from_time && to_time
      from_time = to_time.beginning_of_day
    elsif !from_time && !to_time
      from_time = Time.now.beginning_of_day
      to_time = Time.now.end_of_day
    end

    raise ArgumentError, "Maximum track time span is one day" if (to_time - from_time) > 1.day

    points = RadarPoint.where(at: from_time..to_time, aircraft_id: params[:aircraft_id].to_i).order(at: :asc)

    respond_to do |format|
      format.json { render json: points.map { |x| { at: x.at, lat: x.lat, lng: x.lng, alt: x.alt } } }
      format.igc { render_igc(points) }
    end
  end

  def track_day
    day = Time.local(params[:year], params[:month], params[:day])

    points = RadarPoint.where(at: day.beginning_of_day..day.end_of_day, aircraft_id: params[:aircraft_id].to_i).order(at: :asc)

    respond_to do |format|
      format.json { render json: points.map { |x| { at: x.at, lat: x.lat, lng: x.lng, alt: x.alt } } }
      format.igc { render_igc(points) }
    end
  end

  def render_igc(points)
    igc = ''
    igc << "A XXX\r\n"
    igc << "HFFXA030\r\n"
    igc << "HFDTE#{day.strftime('%y%m%d')}\r\n"
    igc << "HFFTYFRTYPE: FLARM SUCKS!\r\n"
    igc << "I013638FXA\r\n"

    points.each do |entry|
      lat = "#{'%02d' % entry.lat.abs}#{('%2.3f' % ((entry.lat.abs % 1.0) * 60)).to_s.gsub('.', '') }#{entry.lat >= 0 ? 'N' : 'S'}"
      lng = "#{'%03d' % entry.lng.abs}#{('%2.3f' % ((entry.lng.abs % 1.0) * 60)).to_s.gsub('.', '') }#{entry.lng >= 0 ? 'E' : 'W'}"

      igc << "B#{entry.at.getutc.strftime('%H%M%S')}#{lat}#{lng}A#{'%05d' % entry.alt}#{'%05d' % entry.alt}0030\r\n"
    end

    render plain: igc
  end

  def generic
    rel = TrackEntry.all
    rel = rel.where(rel.arel_table[:at].gt(params[:from])) if params[:from]
    rel = rel.where(rel.arel_table[:at].lt(params[:to])) if params[:to]
    rel = rel.where(aircraft_id: params[:aircraft_id]) if params[:aircraft_id]
    rel = rel.order(at: :asc)

    respond_to do |format|
      format.json { render :json => rel.all.map { |x| { at: x.at, lat: x.lat, lng: x.lng, alt: x.alt, cog: x.cog, sog: x.sog, cr: x.cr, tr: x.tr } } }
    end
  end
end

end
end
