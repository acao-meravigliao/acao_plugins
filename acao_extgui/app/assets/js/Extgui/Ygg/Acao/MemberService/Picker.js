/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.MemberService.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.MemberService',
    'Extgui.Ygg.Acao.MemberService.View',
  ],
  alias: 'widget.acao_member_service_picker',

  extguiObject: 'Extgui.Ygg.Acao.MemberService',

  searchIn: [ ],
  defaultSortField: 'id',
  sortFields: [
//    { label: 'Identifier', field: 'identifier' },
  ],
});

