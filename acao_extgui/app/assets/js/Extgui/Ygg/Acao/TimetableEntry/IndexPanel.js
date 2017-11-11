/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.TimetableEntry.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.TimetableEntry',
    'Ygg.Acao.Aircraft',
    'Ygg.Acao.Airfield',
  ],
  alias: 'widget.acao_timetable',

  title: 'Acao TimetableEntrys',
  model: 'Ygg.Acao.TimetableEntry',
  storeConfig: {
    sorters: {
      property: 'created_at',
      direction: 'DESC',
    },
  },
  columns: [
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'aircraft.registration',
    tpl: '<tpl if="aircraft">{[ values.aircraft.registration || values.aircraft.flarm_identifier ]}</tpl>',
    filterable: true,
    searchable: true,
    width: 100,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'pilot.name',
    tpl: '<tpl if="pilot">{pilot.person.first_name} {pilot.person.last_name}</tpl>',
    searchable: true,
    width: 100,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'created_at',
    filterable: true,
    searchable: true,
    hidden: true,
    width: 90,
    format: 'H:i:s',
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'takeoff_at',
    filterable: true,
    searchable: true,
    width: 90,
    format: 'H:i:s',
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'takeoff_airfield.name',
    tpl: '<tpl if="takeoff_airfield">{[ values.takeoff_airfield.icao_code || values.takeoff_airfield.name ]}<tpl else>' +
           '<tpl if="takeoff_location">{takeoff_location.lat},{takeoff_location.lng}<tpl else></tpl></tpl>',
    searchable: true,
    width: 150,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'landing_at',
    filterable: true,
    searchable: true,
    width: 90,
    format: 'H:i:s',
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'landing_airfield.name',
    tpl: '<tpl if="landing_airfield">{[ values.landing_airfield.icao_code || values.landing_airfield.name ]}<tpl else>' +
           '<tpl if="landing_location">{landing_location.lat},{landing_location.lng}<tpl else></tpl></tpl>',
    searchable: true,
    width: 150,
   },
   {
    xtype: 'numbercolumn',
    dataIndex: 'tow_height',
    width: 70,
    format: '0',
   },
   {
    xtype: 'numbercolumn',
    dataIndex: 'tow_duration',
    width: 70,
    format: '0',
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'towed_by.aircraft',
    tpl: '<tpl if="towed_by">{[ values.towed_by.aircraft.registration || values.towed_by.aircraft.flarm_identifier ]}</tpl>',
    width: 100,
    dataRecurse: { towed_by: { aircraft: true } },
   },
   {
    dataIndex: 'reception_state',
    width: 70,
   },
   {
    dataIndex: 'flying_state',
    width: 70,
   },
   {
    dataIndex: 'tow_state',
    width: 70,
   },
  ],
  actions: [
  ],
});
