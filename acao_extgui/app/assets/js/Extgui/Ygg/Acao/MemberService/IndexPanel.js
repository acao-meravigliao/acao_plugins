/*
 * Copyright (C) 2017-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.MemberService.IndexPanel', {
  extend: 'Extgui.object.index.GridPanelBase',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.MemberService',
    'Extgui.Ygg.Core.Person',
    'Extgui.Ygg.Acao.ServiceType',
    'Extgui.Ygg.Acao.Payment',
  ],

  model: 'Ygg.Acao.MemberService',

  storeConfig: {
    sorters: {
      property: 'valid_to',
      direction: 'DESC',
    },
  },

  columns: [
   {
    xtype: 'stringtemplatecolumn',
    tpl: '{person.first_name} {person.last_name}',
    dataIndex: 'person',
    searchable: true,
    searchIn: [ 'person.first_name', 'person.last_name' ],
    width: 250,
   },
   {
    xtype: 'stringtemplatecolumn',
    tpl: '{service_type.name}',
    dataIndex: 'service_type',
    searchable: true,
    searchIn: [ 'servie_type.name' ],
    width: 250,
   },
   {
    xtype: 'stringtemplatecolumn',
    tpl: '{payment.identifier}',
    dataIndex: 'payment',
    searchable: true,
    searchIn: [ 'payment.identifier' ],
    width: 250,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'valid_from',
    width: 200,
    filterable: true,
   },
   {
    xtype: 'datecolumn',
    dataIndex: 'valid_to',
    width: 200,
    filterable: true,
   },
  ],

  actions: [
   {
    name: 'new',
    i18nText: 'extgui.acao.member.service.index_panel.action.new',
    iconCls: 'icon-add',
   },
  ],
});
