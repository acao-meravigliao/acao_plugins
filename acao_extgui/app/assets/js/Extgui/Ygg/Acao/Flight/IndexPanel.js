/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Flight.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Flight',
    'Ygg.Acao.Aircraft',
    'Ygg.Core.Person',
  ],

  title: 'Acao Flights',
  model: 'Ygg.Acao.Flight',

  storeConfig: {
    sorters: {
      property: 'takeoff_time',
      direction: 'DESC',
    },
  },

  columns: [
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'aircraft.registration',
    tpl: '<tpl if="aircraft">{aircraft.registration}</tpl>',
    width: 80,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    searchIn: [ 'pilot1.first_name', 'pilot1.last_name' ],
    tpl: '<tpl if="pilot1">{pilot1.first_name} {pilot1.last_name}</tpl>',
    width: 200,
    filterable: false,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    searchIn: [ 'pilot2.first_name', 'pilot2.last_name' ],
    tpl: '<tpl if="pilot2">{pilot2.first_name} {pilot2.last_name}</tpl>',
    width: 200,
    filterable: false,
    searchable: true,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'takeoff_time',
    filterable: true,
    format: 'Y-m-d H:i',
    width: 150,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'landing_time',
    filterable: true,
    format: 'Y-m-d H:i',
    width: 150,
   },
  ],

  actions: [
  ],
});
