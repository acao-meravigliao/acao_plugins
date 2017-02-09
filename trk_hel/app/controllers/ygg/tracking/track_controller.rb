#
# Copyright (C) 2015-2015, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#
#/

module Ygg
module Tracking

class TrackController < ActionController::Base

  layout false

  def index
    day = Time.local(params[:year], params[:month], params[:day])

    @aircrafts = TrackEntry.select(:aircraft_id).where(at: day.beginning_of_day..day.end_of_day).group(:aircraft_id).joins(:aircraft)

    respond_to do |format|
      format.json { render :json => @aircrafts.map { |x| { aircraft_id: x.aircraft_id, reg: x.aircraft.registration } } }
    end
  end

  def track
    day = Time.local(params[:year], params[:month], params[:day])

    entries = TrackEntry.where(at: day.beginning_of_day..day.end_of_day, aircraft_id: params[:aircraft_id]).order(at: :asc)

    # TODO read and stream records to output without buffering

    igc = []
    igc << "A XXX"
    igc << "HFFXA030"
    igc << "HFDTE#{day.strftime('%y%m%d')}"
    igc << "HFFTYFRTYPE: FLARM SUCKS!"
    igc << "I013638FXA"

    entries.each do |entry|
      lat = "#{'%02d' % entry.lat.abs}#{('%2.3f' % ((entry.lat.abs % 1.0) * 60)).to_s.gsub('.', '') }#{entry.lat >= 0 ? 'N' : 'S'}"
      lng = "#{'%03d' % entry.lng.abs}#{('%2.3f' % ((entry.lng.abs % 1.0) * 60)).to_s.gsub('.', '') }#{entry.lng >= 0 ? 'E' : 'W'}"

      igc << "B#{entry.at.getutc.strftime('%H%M%S')}#{lat}#{lng}A#{'%05d' % entry.alt}#{'%05d' % entry.alt}0030"
    end

    respond_to do |format|
      format.json { render :json => entries.map { |x| { at: x.at, lat: x.lat, lng: x.lng, alt: x.alt } } }
      format.igc { render :plain => igc.join("\r\n") }
    end
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

  def sw_getprotocolinfo
    render :plain => {
      version: '1.3',
      date: Time.now.strftime('%y%m%d'),
      time: Time.now.to_i,
    }.map { |k,v| "{#{k.to_s}}#{v}{/#{k.to_s}}" }.join('')
  end

  def sw_get_aircrafts_by_day
    pbd = {}

    Ygg::Tracking::DayAircraft.order(day: :asc).order(aircraft_id: :asc).each do |aircraftday|
      pbd[aircraftday.day] ||= []
      pbd[aircraftday.day] << aircraftday.aircraft_id
    end

    render :json => pbd
  end

  def sw_get_aircraft
    pbd = {}

    aircraft = Ygg::Acao::Aircraft.find(params[:id])

    render :json => aircraft.ar_serializable_hash(:rest)
  end

  def sw_getactivecontests
    contests = Ygg::Tracking::Contest.all.map { |contest|
     {
      contestname: contest.name,
      contestdisplayname: contest.display_name,
      datadelay: contest.data_delay,
      utcoffset: '%+03d:00' % contest.utc_offset,
      countrycode: contest.country_code,
      site: contest.site,
      fromdate: contest.from_date,
      todate: contest.to_date,
      lat: contest.lat,
      lon: contest.lng,
      alt: contest.alt,
     }.map { |k,v| "{#{k.to_s}}#{v}{/#{k.to_s}}" }.join('')
    }.join('')

    render :plain => contests
  end

  def sw_getcontestinfo
    contest = Ygg::Tracking::Contest.find_by_name!(params[:contestname])

    if params[:date]
      render :plain => contest.days.find_by_day(Time.parse(params[:date])).cuc_file
      return
    end

    days = contest.days.all.map { |day|
     {
      date: day.date.strftime('%Y%m%d'),
      task: day.task ? '1' : '0',
      validday: day.valid_day ? '1' : '0',
     }.map { |k,v| "{#{k.to_s}}#{v}{/#{k.to_s}}" }.join('')
    }.join("\n")

    render :plain => days
  end

  def sw_gettrackerdata
    starttime = Time.parse(params[:starttime] + '+0000')
    endtime = Time.parse(params[:endtime] + '+0000')

    entries = TrackEntry.where(at: starttime..endtime, aircraft_id: params[:trackerid]).order(at: :asc)

    out = "{datadelay}0{/datadelay}\n"

    entries.each do |entry|
      out << "#{entry.aircraft_id},#{entry.at.getutc.strftime('%Y%m%d%H%M%S')},#{entry.lat},#{entry.lng},#{'%.1f' % entry.alt},1\n"
    end

    render :plain => out, :content_type => 'text/plain'
  end


end

end
end
