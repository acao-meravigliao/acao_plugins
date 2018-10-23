/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Invoice.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Invoice',
    'Extgui.Ygg.Core.Person.ReferenceField',
  ],

  title: 'Acao Invoices',
  model: 'Ygg.Acao.Invoice',

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
    dataIndex: 'first_name',
    width: 230,
    filterable: true,
    searchable: true,
   },
   {
    dataIndex: 'last_name',
    width: 230,
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
    xtype: 'decimalcolumn',
    dataIndex: 'total',
    width: 120,
    tdCls: 'price',
    fmtFixed: 2,
    align: 'right',
    unit: '€',
   },
   {
    dataIndex: 'state',
    width: 230,
    filterable: true,
    searchable: true,
   },
   {
    dataIndex: 'payment_state',
    width: 230,
    filterable: true,
    searchable: true,
   },
  ],

  actions: [
  ],
});
