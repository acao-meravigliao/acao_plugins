/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.RosterDay.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.RosterDay',
  ],

//  title: 'Acao Service Types',
  model: 'Ygg.Acao.RosterDay',

  storeConfig: {
    sorters: {
      property: 'date',
      direction: 'ASC',
    },
  },

  columns: [
   {
    xtype: 'datecolumn',
    dataIndex: 'date',
    width: 80,
    filterable: true,
   },
   {
    xtype: 'checkcolumn',
    dataType: 'high_season',
    width: 80,
    filterable: true,
   },
   {
    xtype: 'numbercolumn',
    dataIndex: 'needed_people',
    width: 80,
    filterable: true,
    format: '0',
   },
   {
    dataIndex: 'descr',
    flex: 1,
    filterable: true,
    searchable: true,
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.roster_day.index_panel.action.new',
    iconCls: 'icon-add',
   },
  ],
});
