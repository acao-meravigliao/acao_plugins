/*
 * Copyright (C) 2018-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.License.Rating.CollectionField', {
  extend: 'Extgui.form.field.CollectionGrid',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.License',
  ],
  alias: 'widget.acao_license_ratings',

  model: 'Ygg.Acao.License.Rating',

  hideHeaders: false,

  columns: [
   {
    dataIndex: 'type',
    text: 'Tipo',
    width: 100,
   },
   {
    dataIndex: 'identifier',
    text: 'Numero',
    flex: 1,
   },
   {
    xtype: 'datecolumn',
    text: 'Emessa Il',
    dataIndex: 'issued_at',
   },
   {
    xtype: 'datecolumn',
    text: 'Valida Fino',
    dataIndex: 'valid_to',
   },
  ],
});
