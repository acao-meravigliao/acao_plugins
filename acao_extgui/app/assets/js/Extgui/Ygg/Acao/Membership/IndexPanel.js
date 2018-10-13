/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Membership.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Membership',
    'Ygg.Acao.Year',
    'Extgui.Ygg.Core.Person',
  ],

  model: 'Ygg.Acao.Membership',

  storeConfig: {
    sorters: {
      property: 'valid_from',
      direction: 'DESC',
    },
  },

  columns: [
   {
    xtype: 'stringtemplatecolumn',
    tpl: '<tpl if="person">{person.first_name} {person.last_name}</tpl>',
    dataIndex: 'person',
    searchable: true,
    searchIn: [ 'person.first_name', 'person.last_name' ],
    width: 250,
   },
   {
    dataIndex: 'status',
    width: 200,
    filterable: true,
    searchable: true,
   },
   {
    xtype: 'stringtemplatecolumn',
    tpl: '{reference_year.year}',
    dataIndex: 'reference_year.year',
    width: 100,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'valid_from',
    width: 200,
    filterable: true,
    format: 'Y-m-d',
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'valid_to',
    width: 200,
    filterable: true,
    format: 'Y-m-d',
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.membership.index_panel.action.new',
    iconCls: 'icon-add',
   },
  ],
});
