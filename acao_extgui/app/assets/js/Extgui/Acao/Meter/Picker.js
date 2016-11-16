/*
 * Copyright (C) 2012-2015, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ca.Certificate.Picker', {
  extend: 'Extgui.object.Picker',
  alias: 'widget.ca_certificate_picker',
  requires: [
    'Extgui.Ca.Plugin',
    'Extgui.Ca.Certificate',
    'Extgui.Ca.Certificate.View',
  ],
  extguiObject: 'Extgui.Ca.Certificate',

  searchIn: [ 'cn', 'email', 'subject_dn', ],
  defaultSorter: 0,
  sorters: [
   { label: 'CN', sorter: 'cn' },
   { label: 'Subject DN', sorter: 'subject_dn' },
   { label: 'EMail', sorter: 'email' },
   { label: 'Valid From', sorter: 'valid_from' },
   { label: 'Valid To', sorter: 'valid_to' },
   { label: 'Issuer CN', sorter: 'issuer_cn' },
   { label: 'Issuer DN', sorter: 'issuer_dn' },
  ],

  createCreateWindow: function() {
    return Ext.create('Extgui.object.CreateWindow', {
      width: 600,
      height: 300,
      modal: true,
      items: {
        xtype: 'modelformpanel',
        model: 'Ygg.Ca.Certificate',
        formMode: 'create',
        title: i18n('extgui.ca.certificate.picker.create_window.title'),
        layout: 'fit',
        items: {
          xtype: 'textarea',
          name: 'pem',
          anchor: '100%',
          cls: 'ca_certificate_area',
        }
      }
    });
  },
});
