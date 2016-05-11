//= require jquery
//= require jquery.sprintf

var wind = {
  initialize: function() {
    var me = this;

    faye.subscribe('/meteo/updates/*', function(message) {
      me.onMessage(message);
    }, null, function() {
      alert('Error subscribing to meteo data!');
    });

    me.meteo = {};
    me.meteo_upd = {};

    me.wxUpdated();

  },

  onMessage: function(message) {
    var me = this;

//console.log("MSG=", message);

    switch(message.type) {
    case 'WX_UPDATE':
      var u = {};

      jQuery.each(message.payload.data, function(k,v) {
        k = message.payload.station_id + '_' + k;

        me.meteo[k] = v;
        me.meteo_upd[k] = Date.parse(message.timestamp);
        u[k] = true;
      });

      me.wxUpdated(u);
    }
  },

  wxUpdated: function(u) {
    var me = this;
    var m = me.meteo;

    u = u || {};

    jQuery.each(me.meteo_upd, function(k,v) {
      if (v < (Date.now() - 15000) && m[k]) {
        u[k] = true;
        m[k] = null;
      }
    });

    if (u.WS_wind_speed) $('#wind_speed').text(m.WS_wind_speed !== undefined ? (m.WS_wind_speed * 1.944).toFixed(1) : "INOP");
    if (u.WS_wind_dir) $('#wind_dir').text(m.WS_wind_dir !== undefined ? m.WS_wind_dir.toFixed(1) : "INOP");

    if (u.WS_wind_dir) {
      if (m.WS_wind_dir !== undefined) {
        $('#needle').show().attr('transform', 'rotate(' + m.WS_wind_dir + ')');
        $('#needle_shadow').show().attr('transform', 'rotate(' + m.WS_wind_dir + ')');
      } else {
        $('#needle').hide();
        $('#needle_shadow').hide();
      }
    }

    if (u.WS_wind_speed) {
      if (m.WS_wind_speed !== undefined) {
        $('#red_slider').attr('transform', 'translate(0,' + (-(m.WS_wind_speed/16.7)*60) + ')');
        $('#red_slider text').text((m.WS_wind_speed * 1.944).toFixed(1));
      } else {
        $('#red_slider text').text("INOP");
      }
    }

    //----------------------------------

    if (u.WS_wind_2m_avg) {
      if (m.WS_wind_2m_avg !== undefined) {
        $('#wind_2m_avg').text((m.WS_wind_2m_avg * 1.944).toFixed(1));
        $('#green_slider').attr('transform', 'translate(0,' + (-(m.WS_wind_2m_avg/16.7)*60) + ')');
        $('#green_slider text').text((m.WS_wind_2m_avg * 1.944).toFixed(1));
      } else {
        $('#wind_2m_avg').text("INOP");
        $('#green_slider text').text("INOP");
      }
    }

    if (u.WS_wind_2m_vec_mag) {
      $('#wind_2m_vec_mag').text(m.WS_wind_2m_vec_mag !== undefined ? (m.WS_wind_2m_vec_mag * 1.944).toFixed(1) : "INOP");
    }

    if (u.WS_wind_2m_vec_dir) {
      $('#wind_2m_vec_dir').text(m.WS_wind_2m_vec_dir !== undefined ? m.WS_wind_2m_vec_dir.toFixed(1) : "INOP");

      if (m.WS_wind_2m_vec_dir !== undefined) {
        $('#needle_2m').show().attr('transform', 'rotate(' + m.WS_wind_2m_vec_dir + ')');
        $('#needle_2m_shadow').show().attr('transform', 'rotate(' + m.WS_wind_2m_vec_dir + ')');
      } else {
        $('#needle_2m').hide();
        $('#needle_2m_shadow').hide();
      }
    }

    if (u.WS_wind_2m_gst) {
      if (m.WS_wind_2m_gst !== undefined) {
        $('#wind_2m_gst').text((m.WS_wind_2m_gst * 1.944).toFixed(1));
        $('#green_slider_gst').show().attr('transform', 'translate(0,' + (-(m.WS_wind_2m_gst/16.7)*60) + ')');
      } else {
        $('#wind_2m_gst').text("INOP");
        $('#green_slider_gst').hide();
      }
    }

    if (u.WS_wind_2m_gst_dir) $('#wind_2m_gst_dir').text(m.WS_wind_2m_gst_dir !== undefined ? m.WS_wind_2m_gst_dir.toFixed(1) : "INOP");

    if (u.WS_wind_2m_gst_ts) {
      if (m.WS_wind_2m_gst_ts !== undefined) {
        var d = new Date(Date.parse(m.WS_wind_2m_gst_ts));
        $('#wind_2m_gst_ts').text($.sprintf("%02d:%02d:%02d", d.getHours(), d.getMinutes(), d.getSeconds()));
      } else
        $('#wind_2m_gst_ts').text("INOP");
    }

    //----------------------------------

    if (u.WS_wind_10m_avg) {
      if (m.WS_wind_10m_avg !== undefined) {
        $('#wind_10m_avg').text((m.WS_wind_10m_avg * 1.944).toFixed(1));
        $('#blue_slider').attr('transform', 'translate(0,' + (-(m.WS_wind_10m_avg/16.7)*60) + ')');
        $('#blue_slider text').text((m.WS_wind_10m_avg * 1.944).toFixed(1));
      } else {
        $('#wind_10m_avg').text("INOP");
        $('#blue_slider text').text("INOP");
      }
    }

    if (u.WS_wind_10m_vec_mag) {
      $('#wind_10m_vec_mag').text(m.WS_wind_10m_vec_mag !== undefined ? (m.WS_wind_10m_vec_mag * 1.944).toFixed(1) : "INOP");
    }

    if (u.WS_wind_10m_vec_dir) {
      $('#wind_10m_vec_dir').text(m.WS_wind_10m_vec_dir !== undefined ? m.WS_wind_10m_vec_dir.toFixed(1) : "INOP");

      if (m.WS_wind_10m_vec_dir !== undefined) {
        $('#needle_10m').show().attr('transform', 'rotate(' + m.WS_wind_10m_vec_dir + ')');
        $('#needle_10m_shadow').show().attr('transform', 'rotate(' + m.WS_wind_10m_vec_dir + ')');
      } else {
        $('#needle_10m').hide();
        $('#needle_10m_shadow').hide();
      }
    }

    if (u.WS_wind_10m_gst) {
      if (m.WS_wind_10m_gst !== undefined) {
        $('#wind_10m_gst').text((m.WS_wind_10m_gst * 1.944).toFixed(1));
        $('#blue_slider_gst').show().attr('transform', 'translate(0,' + (-(m.WS_wind_10m_gst/16.7)*60) + ')');
      } else {
        $('#wind_10m_gst').text("INOP");
        $('blue_slider_gst').hide();
      }
    }

    if (u.WS_wind_10m_gst_dir) $('#wind_10m_gst_dir').text(m.WS_wind_10m_gst_dir !== undefined ? m.WS_wind_10m_gst_dir.toFixed(1) : "INOP");

    if (u.WS_wind_10m_gst_ts) {
      if (m.WS_wind_10m_gst_ts !== undefined) {
        var d = new Date(Date.parse(m.WS_wind_10m_gst_ts));
        $('#wind_10m_gst_ts').text($.sprintf("%02d:%02d:%02d", d.getHours(), d.getMinutes(), d.getSeconds()));
      } else
        $('#wind_10m_gst_ts').text("INOP");
    }

    //----------------------------------

    if (u.WS_qfe) $('#qfe').text(m.WS_qfe !== undefined ? (m.WS_qfe / 100).toFixed(0) : "INOP");
    if (u.WS_qfe_h) $('#qfe_h').text(m.WS_qfe_h !== undefined ? m.WS_qfe_h.toFixed(1) : "INOP");
    if (u.WS_qnh) $('#qnh').text(m.WS_qnh !== undefined ? (m.WS_qnh / 100).toFixed(0) : "INOP");
    if (u.WS_isa_h) $('#isa_h').text(m.WS_isa_h !== undefined ? m.WS_isa_h.toFixed(1) : "INOP");

    if (u.WS_temperature) $('#wind_temperature').text(m.WS_temperature !== undefined ? m.WS_temperature.toFixed(1) : "INOP");
    if (u.OMM_temperature) $('#temperature').text(m.OMM_temperature !== undefined ? m.OMM_temperature.toFixed(1) : "INOP");
    if (u.OMM_humidity) $('#humidity').text(m.OMM_humidity !== undefined ? m.OMM_humidity.toFixed(1) : "INOP");
    if (u.OMM_dewpoint) $('#dewpoint').text(m.OMM_dewpoint !== undefined ? m.OMM_dewpoint.toFixed(1) : "INOP");

    if (me.periodic)
      clearTimeout(me.periodic);

    me.periodic = setTimeout(function() {
      me.wxUpdated();
    }, 15000);

  },
};

var faye = new Faye.Client(app.faye_interface_uri);

$( document ).ready(function() {
  wind.initialize();
});
