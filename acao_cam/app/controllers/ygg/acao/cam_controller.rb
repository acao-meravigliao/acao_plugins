#
# Copyright (C) 2014-2017, Daniele Orlandi
#
# Author:: Daniele Orlandi <daniele@orlandi.com>
#
# License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
#

require 'date'

module Ygg
module Acao

class CamController < ActionController::Base
  CAMS = {
    cam1: {
      dir: 'cam1',
      live_playlist: '/cam/cam1/live.m3u8',
      livelapse_playlist: '/cam/cam1/livelapse.m3u8',
      idle_image: '/cam/cam1/idle.jpg',
      variants: {
        '450': {
          width: 800,
          height: 450,
          bandwidth: 75000,
        },
#        '720': {
#          width: 1280,
#          height: 720,
#          bandwidth: 300000,
#        },
        '1080': {
          width: 1920,
          height: 1080,
          bandwidth: 400000,
        },
      },
    },
    cam2: {
      dir: 'cam2',
      live_playlist: '/cam/cam2/live.m3u8',
      livelapse_playlist: '/cam/cam2/livelapse.m3u8',
      idle_image: '/cam/cam2/idle.jpg',
      variants: {
        '450': {
          width: 800,
          height: 450,
          bandwidth: 75000,
        },
#        '720': {
#          width: 1280,
#          height: 720,
#          bandwidth: 300000,
#        },
        '1080': {
          width: 1920,
          height: 1080,
          bandwidth: 400000,
        },
      },
    },
    cam3: {
      dir: 'cam3',
      live_playlist: '/cam/cam3/live.m3u8',
      livelapse_playlist: '/cam/cam3/livelapse.m3u8',
      idle_image: '/cam/cam3/idle.jpg',
      variants: {
        '450': {
          width: 800,
          height: 450,
          bandwidth: 75000,
        },
#        '720': {
#          width: 1280,
#          height: 720,
#          bandwidth: 300000,
#        },
#        '1080': {
#          width: 1920,
#          height: 1080,
#          bandwidth: 400000,
#        },
      },
    },
    cam6: {
      dir: 'cam6',
      live_playlist: '/cam/cam6/live.m3u8',
      livelapse_playlist: '/cam/cam3/livelapse.m3u8',
      idle_image: '/cam/cam6/idle.jpg',
      variants: {
        '450': {
          width: 800,
          height: 450,
          bandwidth: 75000,
        },
#        '720': {
#          width: 1280,
#          height: 720,
#          bandwidth: 300000,
#        },
        '1080': {
          width: 1920,
          height: 1080,
          bandwidth: 400000,
        },
      },
    },
  }

#  def tdir
#    File.join(Rails.root, 'public', 'cam', @cam[:dir], 'timelapses')
#  end
#
#  def pdir
#    File.join('/cam', @cam[:dir], 'timelapses')
#  end
#
#
#
#  def player
#    @cam = CAMS[params[:name].to_sym]
#    @files = {}
#
#
#    Dir.open(tdir).each do |f|
#      next unless f =~ /^(\d\d\d\d)(\d\d)(\d\d)_(.*)\.mp4$/
#
#      date = Date.new($1.to_i, $2.to_i, $3.to_i)
#
#      @files[date] ||= { title: "Timelapse", variants: {}, description: "Timelapse for #{date.to_s}"  }
#      @files[date][:variants][$5] = { file: File.join(pdir, f), label: $5 }
#    end
#
##    @files.each { |k,v| @files[k] = Hash[@files[k].sort.reverse] }
#
#    @playlist = [
#     {
#      image: @cam[:idle_image],
#      title: 'Today',
#      description: 'Today Timelapse',
#      file: @cam[:livelapse_playlist],
#     },
#     {
#      image: @cam[:idle_image],
#      title: 'Live!',
#      description: 'Live camera',
#      file: @cam[:live_playlist],
#     },
#    ]
#
#    Hash[@files.sort.reverse].each do |date, content|
#      @playlist << {
#        image: @cam[:idle_image],
#        title: content[:title],
#        description: content[:description],
#        mediaid: "acao_timelapse_#{params[:name]}_#{date.strftime('%Y%m%d')}",
#        sources: content[:variants].map { |k,v| v },
#      }
#    end
#
#    render layout: 'fullscreen'
#  end

  def live
    @cam = CAMS[params[:name].to_sym]
    @width = params[:width] || 640
    @height = params[:width] || 480

    @autostart = params[:autostart] != '0'

    @idle_image = @cam[:idle_image]
    @title = 'Live stream'
    @description = 'Live stream'
    @mediaid = ''

    @sources = [ { file: @cam[:live_playlist], label: params[:name] } ]

    response.headers['X-Frame-Options'] = 'GOFORIT'
    response.headers['X-XSS-Protection'] = '0'

    render action: 'player', layout: 'fullscreen'
  end

  def live_m3u8
    out = "#EXTM3U\n"

    CAMS[params[:name].to_sym][:variants].each do |variant_name, variant|
      out << "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=#{variant[:bandwidth]},RESOLUTION=#{variant[:width]}x#{variant[:height]}\n"
      out << "live/#{variant_name}.m3u8\n"
    end

    render plain: out, content_type: 'application/x-mpegURL'
  end

  def livelapse
    @cam = CAMS[params[:name].to_sym]
    @width = params[:width] || 640
    @height = params[:width] || 480

    @autostart = params[:autostart] != '0'

    @idle_image = @cam[:idle_image]
    @title = 'Livelapse'
    @description = 'Realtime-generated timelapse'
    @mediaid = ''

    @sources = [ { file: @cam[:livelapse_playlist], label: params[:name] } ]

    response.headers['X-Frame-Options'] = 'GOFORIT'
    response.headers['X-XSS-Protection'] = '0'

    render action: 'player', layout: 'fullscreen'
  end

#  def find_video
#    @mediaid = params[:mediaid]
#
#    if !(@mediaid =~ /^(.*)_(\d\d\d\d)(\d\d)(\d\d)$/)
#      render status: 404
#      return
#    end
#
#    @date = Date.new($2.to_i, $3.to_i, $4.to_i)
#
#    if $1 == 'acao_timelapse'
#      @title = "ACAO Timelapse #{@date.strftime('%Y-%m-%d')}"
#      @description = "Timelapse for ACAO Webcam recorded on #{@date.strftime('%Y-%m-%d')}"
#      @dir = 'timelapses'
#      @source = 'cam'
#    else
#      render status: 404
#      return
#    end
#
#    @timestamp = @date.strftime('%Y%m%d')
#
#    tdir = File.join(Rails.root, 'public', @dir)
#    pdir = '/' + @dir
#
#    @variants = {}
#    Dir.open(tdir).each do |f|
#      next unless f =~ /^#{@source}_#{@timestamp}_(.*)\.mp4$/
#
#      @variants[$1] = { file: File.join(pdir, f), label: $1 }
#    end
#
#    @variants.sort
#
#    @sources = @variants.map { |k,v| v }
#    @file_url = root_url + @variants.values.first[:file]
#  end
#
#  def video
#    find_video
#  end
#
#  def embed
#    find_video
#
#    render layout: 'embed'
#  end
end

end
end
