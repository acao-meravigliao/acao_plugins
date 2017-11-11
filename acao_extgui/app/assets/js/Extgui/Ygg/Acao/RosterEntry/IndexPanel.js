/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.RosterEntry.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.RosterEntry',
  ],

//  title: 'Acao Service Types',
  model: 'Ygg.Acao.RosterEntry',

  storeConfig: {
    sorters: {
      property: 'name',
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
    xtype: 'stringtemplatecolumn',
    dataIndex: 'person',
    width: 250,
    tpl: '<tpl if="person">{person.first_name} {person.last_name}</tpl>',
   },
   {
    xtype: 'checkcolumn',
    dataIndex: 'chief',
    filterable: true,
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.roster_entry.index_panel.action.new',
    iconCls: 'icon-add',
   },
  ],
});
