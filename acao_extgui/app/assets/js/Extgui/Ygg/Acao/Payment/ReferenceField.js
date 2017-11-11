/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Payment.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Payment',
    'Extgui.Ygg.Acao.Payment',
    'Extgui.Ygg.Acao.Payment.Picker',
  ],
  alias: 'widget.acao_payment',

  extguiObject: 'Extgui.Ygg.Acao.Payment',
  pickerClass: 'Extgui.Ygg.Acao.Payment.Picker',
});
