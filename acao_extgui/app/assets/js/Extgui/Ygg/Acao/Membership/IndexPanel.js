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
  ],

  model: 'Ygg.Acao.Membership',

  storeConfig: {
    sorters: {
      property: 'membership',
      direction: 'ASC',
    },
  },

  columns: [
   {
    dataIndex: 'membership',
    flex: 1,
    filterable: true,
    searchable: true,
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
