/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.RosterDay.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.RosterDay',
    'Extgui.Ygg.Acao.RosterDay',
    'Extgui.Ygg.Acao.RosterDay.Picker',
  ],
  alias: 'widget.acao_roster_day',

  extguiObject: 'Extgui.Ygg.Acao.RosterDay',
  pickerClass: 'Extgui.Ygg.Acao.RosterDay.Picker',
});
