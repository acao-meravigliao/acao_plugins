/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.RosterEntry.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.RosterEntry',
    'Extgui.Ygg.Acao.RosterEntry',
    'Extgui.Ygg.Acao.RosterEntry.Picker',
  ],
  alias: 'widget.acao_roster_entry',

  extguiObject: 'Extgui.Ygg.Acao.RosterEntry',
  pickerClass: 'Extgui.Ygg.Acao.RosterEntry.Picker',
});
