/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Flight.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Flight',
    'Extgui.Ygg.Acao.Flight',
    'Extgui.Ygg.Acao.Flight.Picker',
  ],
  alias: 'widget.acao_flight',

  extguiObject: 'Extgui.Ygg.Acao.Flight',
  pickerClass: 'Extgui.Ygg.Acao.Flight.Picker',
});
