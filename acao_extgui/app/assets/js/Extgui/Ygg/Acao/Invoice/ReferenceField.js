/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Invoice.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Invoice',
    'Extgui.Ygg.Acao.Invoice',
    'Extgui.Ygg.Acao.Invoice.Picker',
  ],
  alias: 'widget.acao_invoice',

  extguiObject: 'Extgui.Ygg.Acao.Invoice',
  pickerClass: 'Extgui.Ygg.Acao.Invoice.Picker',
});
