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
      property: 'id',
      direction: 'ASC',
    },
  },

  columns: [
   {
//    xtype: 'textcolumn',
    dataIndex: 'code',
    width: 80,
    filterable: true,
    searchable: true,
   },
  ],

  actions: [
  ],
});
