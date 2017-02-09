/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Tracker.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Tracker',
    'Ygg.Acao.Aircraft',
  ],

  title: 'Acao Trackers',
  model: 'Ygg.Acao.Tracker',
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
    dataIndex: 'type',
    filterable: true,
    searchable: true,
    width: 70,
   },
   {
    dataIndex: 'identifier',
    filterable: true,
    searchable: true,
    flex: 1,
   },
  ],
  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.meter.index_panel.action.new',
    iconCls: 'icon-add',
   }
  ],
});
