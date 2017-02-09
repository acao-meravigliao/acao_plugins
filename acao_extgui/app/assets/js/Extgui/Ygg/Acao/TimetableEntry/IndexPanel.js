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
  ],

  title: 'Acao TimetableEntrys',
  model: 'Ygg.Acao.TimetableEntry',
  storeConfig: {
    sorters: {
      property: 'identifier',
      direction: 'ASC',
    },
  },
  columns: [
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'aircraft.registration',
    tpl: '<tpl if="aircraft">{aircraft.registration}</tpl>',
    filterable: true,
    searchable: true,
    width: 100,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'pilot.name',
    tpl: '<tpl if="aircraft">{pilot.person.first_name} {pilot.person.last_name}</tpl>',
    searchable: true,
    width: 100,
   },
   {
    dataIndex: 'takeoff_at',
    filterable: true,
    searchable: true,
    width: 70,
   },
   {
    dataIndex: 'landing_at',
    filterable: true,
    searchable: true,
    width: 70,
   },
   {
    dataIndex: 'tow_height',
    width: 70,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'towed_by.aircraft.registration',
    tpl: '<tpl if="aircraft">{towed_by.aircraft.registration}</tpl>',
    filterable: true,
    searchable: true,
    width: 100,
   },
  ],
  actions: [
  ],
});
