/*
 * Copyright (C) 2017-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Medical.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Medical',
    'Extgui.Ygg.Core.Person',
  ],

  model: 'Ygg.Acao.Medical',

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
    width: 200,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'valid_to',
    width: 200,
    filterable: true,
    searchable: true,
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.medical.index_panel.action.new',
    iconCls: 'icon-add',
   },
  ],
});
