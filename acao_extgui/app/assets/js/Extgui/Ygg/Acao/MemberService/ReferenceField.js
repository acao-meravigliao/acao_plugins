/*
 * Copyright (C) 2017-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.MemberService.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.MemberService',
    'Extgui.Ygg.Acao.MemberService',
    'Extgui.Ygg.Acao.MemberService.Picker',
  ],
  alias: 'widget.acao_member_service',

  extguiObject: 'Extgui.Ygg.Acao.MemberService',
  pickerClass: 'Extgui.Ygg.Acao.MemberService.Picker',
});
