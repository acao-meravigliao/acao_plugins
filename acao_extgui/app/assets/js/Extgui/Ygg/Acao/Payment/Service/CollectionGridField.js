/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Payment.Service.CollectionGridField', {
  extend: 'Extgui.form.field.CollectionGrid',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Payment',
    'Extgui.Ygg.Acao.ServiceType',
  ],
  alias: 'widget.acao_payment_services_grid',

  model: 'Ygg.Acao.Payment.Service',

  hideHeaders: false,

  columns: [
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'service_type.symbol',
    text: 'Simbolo',
    tpl: '{service_type.symbol}',
    width: 160,
   },
   {
    xtype: 'stringtemplatecolumn',
    dataIndex: 'service_type.name',
    text: 'Servizio',
    tpl: '{service_type.name}',
    flex: 1,
   },
   {
    dataIndex: 'extra_info',
    text: 'Extra Info',
    width: 100,
    flex: 1,
   },
   {
    xtype: 'decimalcolumn',
    dataIndex: 'price',
    text: 'Servizio',
    width: 100,
    tdCls: 'price',
    fmtFixed: 2,
    align: 'right',
    unit: '€',
   },
  ],

  dockedItems: [{
    xtype: 'toolbar',
    dock: 'bottom',
    items: [
     {
      xtype: 'component',
      html: '<strong>Totale</strong>',
      flex: 1,
     },
     {
      xtype: 'decimalnumberfield',
      name: 'total_price',
      align: 'right',
      fieldCls: 'price',
      width: 100,
      fmtFixed: 2,
      unit: '€',
      readOnly: true,
      isFormField: undefined,
     },
    ],
  }],

  initComponent: function() {
    var me = this;

    me.callParent(arguments);

    me.getStore().on('datachanged', function() {
      var totalPrice = Big(0);

      Ext.Array.each(me.getStore().getRange(), function(item) {
        totalPrice = totalPrice.plus(item.get('price'));
      });

      me.down('decimalnumberfield[name=total_price]').setValue(totalPrice);
    });

    // Prevent automatic openuri from controller
    me.on('itemdblclick', function(el, record, item, index, e) {
      e.preventDefault(); return false;
   });
  },



});
