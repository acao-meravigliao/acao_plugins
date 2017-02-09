/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Tracker.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Tracker',
    'Extgui.Ygg.Acao.Tracker',
    'Extgui.Ygg.Acao.Tracker.Picker',
  ],
  alias: 'widget.acao_tracker',

  extguiObject: 'Extgui.Ygg.Acao.Tracker',
  pickerClass: 'Extgui.Ygg.Acao.Tracker.Picker',
});
