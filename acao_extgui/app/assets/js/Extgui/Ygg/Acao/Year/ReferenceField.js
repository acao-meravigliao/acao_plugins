/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Year.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Year',
    'Extgui.Ygg.Acao.Year',
    'Extgui.Ygg.Acao.Year.Picker',
  ],
  alias: 'widget.acao_year',

  extguiObject: 'Extgui.Ygg.Acao.Year',
  pickerClass: 'Extgui.Ygg.Acao.Year.Picker',
});
