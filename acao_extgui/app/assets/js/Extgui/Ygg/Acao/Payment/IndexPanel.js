/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Payment.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Payment',
    'Extgui.Ygg.Core.Person.ReferenceField',
  ],

  model: 'Ygg.Acao.Payment',

  storeConfig: {
    sorters: {
      property: 'created_at',
      direction: 'DESC',
    },
  },

  columns: [
   {
    dataIndex: 'identifier',
    width: 80,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'person.acao_code',
    tpl: '<tpl if="person">{person.acao_code}</tpl>',
    filterable: true,
    width: 100,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'person.first_name',
    tpl: '<tpl if="person">{person.first_name}</tpl>',
    searchable: true,
    filterable: true,
    width: 100,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'person.last_name',
    tpl: '<tpl if="person">{person.last_name}</tpl>',
    searchable: true,
    filterable: true,
    width: 100,
   },
   {
    dataIndex: 'state',
    width: 120,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'created_at',
    filterable: true,
    width: 140,
    format: 'Y-m-d H:i',
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'expires_at',
    filterable: true,
    width: 140,
    format: 'Y-m-d H:i',
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'completed_at',
    filterable: true,
    width: 140,
    format: 'Y-m-d H:i',
   },
   {
    xtype: 'decimalcolumn',
    dataIndex: 'amount',
    width: 100,
    tdCls: 'price',
    fmtFixed: 2,
    align: 'right',
    unit: '€',
   },
  ],

  actions: [
  ],
});
