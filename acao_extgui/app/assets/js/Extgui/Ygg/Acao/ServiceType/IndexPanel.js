/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.ServiceType.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.ServiceType',
  ],

  title: 'Acao Service Types',
  model: 'Ygg.Acao.ServiceType',

  storeConfig: {
    sorters: {
      property: 'name',
      direction: 'ASC',
    },
  },

  columns: [
   {
//    xtype: 'textcolumn',
    dataIndex: 'symbol',
    width: 80,
    filterable: true,
    searchable: true,
   },
   {
//    xtype: 'textcolumn',
    dataIndex: 'name',
    flex: 1,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'decimalcolumn',
    dataIndex: 'price',
    width: 80,
    filterable: true,
    unit: '€',
    fmtFixed: 2,
    tdCls: 'price',
    align: 'right',
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.service_type.index_panel.action.new',
    iconCls: 'icon-add',
   },
  ],
});
