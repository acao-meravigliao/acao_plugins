/*
 * Copyright (C) 2016-2016, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.RosterEntry', {
  extend: 'Extgui.object.Base',
  requires: [
    'Extgui.Acao.Plugin',
  ],
  singleton: true,

  model: 'Ygg.Acao.RosterEntry',

//  subTpl: [
//    '<span class="name">{}</span><br />{}',
//  ],
});
