/*
 * Copyright (C) 2017-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.License.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.License',
    'Ygg.Acao.Pilot',
    'Extgui.Ygg.Core.Person',
  ],

  model: 'Ygg.Acao.License',

  storeConfig: {
    sorters: {
      property: 'valid_to',
      direction: 'DESC',
    },
  },

  columns: [
   {
    xtype: 'stringtemplatecolumn',
    tpl: '{pilot.first_name} {pilot.last_name}',
    dataIndex: 'pilot',
    searchable: true,
    searchIn: [ 'pilot.first_name', 'pilot.last_name' ],
    width: 250,
   },
   {
    dataIndex: 'type',
    width: 200,
    filterable: true,
    searchable: true,
   },
   {
    dataIndex: 'identifier',
    width: 200,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'issued_at',
    width: 100,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'valid_to',
    width: 100,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'valid_to2',
    width: 100,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'ratings',
    flex: 1,
    tpl: '<tpl for="ratings"><tpl if="xindex &gt; 1">, </tpl>{type}</tpl>',
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.license.index_panel.action.new',
    iconCls: 'icon-add',
   },
  ],
});
