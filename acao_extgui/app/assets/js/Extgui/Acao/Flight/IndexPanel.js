/*
 * Copyright (C) 2014-2014, Intercom Srl, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *          Lele Forzani <lele@windmill.it>
 *          Alfredo Cerutti <acerutti@intercom.it>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Flight.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Acao.Plugin',
    'Ygg.Acao.Flight',
    'Ygg.Acao.Plane',
    'Ygg.Core.Person',
  ],

  title: 'Acao Flights',
  model: 'Ygg.Acao.Flight',

  storeConfig: {
    sorters: {
      property: 'takeoff_at',
      direction: 'DESC',
    },
  },

  scopes: {
    glider_flights: { text: 'Voli in aliante' },
    motorglider_flights: { text: 'Voli in motoaliante' },
    pax_flights: { text: 'Voli come passeggero' },
    tow_flights: { text: 'Voli traino' },
  },

  columns: [
   {
    xtype: 'stringtemplatecolumn',
    text: 'Aliante',
    dataIndex: 'plane.registration',
    tpl: '<tpl if="plane">{plane.registration}</tpl>',
    width: 80,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    text: 'Aliante P1',
    searchIn: [ 'plane_pilot1.first_name', 'plane_pilot1.last_name' ],
    tpl: '<tpl if="plane_pilot1">{plane_pilot1.first_name} {plane_pilot1.last_name}</tpl>',
    width: 200,
    filterable: false,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    text: 'Aliante P2',
    searchIn: [ 'plane_pilot2.first_name', 'plane_pilot2.last_name' ],
    tpl: '<tpl if="plane_pilot2">{plane_pilot2.first_name} {plane_pilot2.last_name}</tpl>',
    width: 200,
    filterable: false,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    text: 'Traino',
    dataIndex: 'towplane.registration',
    tpl: '<tpl if="towplane">{towplane.registration}</tpl>',
    width: 80,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    text: 'Traino P1',
    searchIn: [ 'towplane_pilot1.first_name', 'towplane_pilot1.last_name' ],
    tpl: '<tpl if="towplane_pilot1">{towplane_pilot1.first_name} {towplane_pilot1.last_name}</tpl>',
    width: 200,
    filterable: false,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    text: 'Traino P2',
    searchIn: [ 'towplane_pilot2.first_name', 'towplane_pilot2.last_name' ],
    tpl: '<tpl if="towplane_pilot2">{towplane_pilot1.first_name} {towplane_pilot2.last_name}</tpl>',
    width: 200,
    filterable: false,
    searchable: true,
    hidden: true,
   },
   {
    xtype: 'datecolumn',
    text: 'Decollo',
    dataIndex: 'takeoff_at',
    filterable: true,
    format: 'Y-m-d H:i',
    width: 150,
   },
   {
    xtype: 'datecolumn',
    text: 'Att. Traino',
    dataIndex: 'towplane_landing_at',
    filterable: true,
    format: 'Y-m-d H:i',
    width: 150,
   },
   {
    xtype: 'datecolumn',
    text: 'Att. Aliante',
    dataIndex: 'landing_at',
    filterable: true,
    format: 'Y-m-d H:i',
    width: 150,
   },
   {
    text: 'Quota',
    dataIndex: 'quota',
    filterable: true,
    width: 70,
   },
   {
    text: 'Bollini',
    dataIndex: 'bollini_volo',
    filterable: true,
    width: 70,
   },
  ],
  actions: [
  ],
});
