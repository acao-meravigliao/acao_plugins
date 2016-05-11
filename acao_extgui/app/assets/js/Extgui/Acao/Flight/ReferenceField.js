/*
 * Copyright (C) 2014-2014, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Flight.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Acao.Plugin',
    'Ygg.Acao.Flight',
    'Extgui.Acao.Flight',
    'Extgui.Acao.Flight.Picker',
  ],
  alias: 'widget.acao_flight',

  extguiObject: 'Extgui.Acao.Flight',
  pickerClass: 'Extgui.Acao.Flight.Picker',
});
