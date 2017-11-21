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

  title: 'Acao Payments',
  model: 'Ygg.Acao.Payment',

  storeConfig: {
    sorters: {
      property: 'created_at',
      direction: 'ASC',
    },
  },

  columns: [
   {
    dataIndex: 'code',
    width: 80,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    header: 'Persona',
    tpl: '<tpl if="person">{person.first_name} {person.last_name}</tpl>',
    searchable: true,
    width: 150,
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
    width: 150,
    header: 'Totale',
    align: 'right',
    renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
      var total = Big(0);
      record.payment_services().each(function(item) { total = total.plus(item.get('price')); });
      return total.toFixed(2) + ' €';
    },
   },
  ],

  actions: [
  ],
});