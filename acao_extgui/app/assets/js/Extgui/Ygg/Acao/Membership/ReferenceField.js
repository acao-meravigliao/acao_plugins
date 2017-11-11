/*
 * Copyright (C) 2017-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Membership.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Membership',
    'Extgui.Ygg.Acao.Membership',
    'Extgui.Ygg.Acao.Membership.Picker',
  ],
  alias: 'widget.acao_membership',

  extguiObject: 'Extgui.Ygg.Acao.Membership',
  pickerClass: 'Extgui.Ygg.Acao.Membership.Picker',
});
