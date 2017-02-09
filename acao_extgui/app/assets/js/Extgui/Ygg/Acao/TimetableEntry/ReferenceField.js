/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.TimetableEntry.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.TimetableEntry',
    'Extgui.Ygg.Acao.TimetableEntry',
    'Extgui.Ygg.Acao.TimetableEntry.Picker',
  ],
  alias: 'widget.acao_timetable_entry',

  extguiObject: 'Extgui.Ygg.Acao.TimetableEntry',
  pickerClass: 'Extgui.Ygg.Acao.TimetableEntry.Picker',
});
