/*
 * Copyright (C) 2012-2015, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ca.Certificate.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ca.Plugin',
    'Extgui.Ca.Certificate',
    'Extgui.Ca.Certificate.Picker',
  ],
  alias: 'widget.ca_certificate',

  extguiObject: 'Extgui.Ca.Certificate',
  pickerClass: 'Extgui.Ca.Certificate.Picker',
});
