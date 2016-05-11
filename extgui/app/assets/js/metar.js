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

    if (u.WS_wind_speed) $('#wind_speed').text(m.WS_wind_speed !== undefined ?
      $.sprintf("%02d KTS", m.WS_wind_speed * 1.944) : "INOP");

    if (u.WS_wind_dir) $('#wind_dir').text(m.WS_wind_dir !== undefined ?
      $.sprintf("%03d°", (m.WS_wind_dir / 10).toFixed() * 10) : "INOP");


    //----------------------------------

    if (u.WS_wind_2m_gst) {
      if (m.WS_wind_2m_gst !== undefined) {
        $('#wind_2m_gst').text($.sprintf("%02d KTS", (m.WS_wind_2m_gst * 1.944)));
      } else {
        $('#wind_2m_gst').text("INOP");
      }
    }

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
