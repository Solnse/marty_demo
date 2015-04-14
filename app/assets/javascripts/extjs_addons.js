/*
Ext.JSON.encodeDate = function(o)
{
    return '"' + Ext.Date.format(o, "Y-m-d'T'H:i:s.uZ") + '"';
}
*/

Ext.ns("Ext.netzke.camp");

/*
 * MultiSelectCombo -- still needs work. I think to use this in a grid
 * we also need to override the getValue() method.
 */
Ext.define('Ext.netzke.camp.MultiSelectCombo', {
    extend: 	'Ext.form.ComboBox',
    alias: 	'widget.multiselectcombo',
    separator: 	",",
    multiSelect: true,

    setValue: function(v){
	if (Ext.isString(v)) {
	    var vArray = v.split(this.separator);
	    this.callParent([vArray]);
	} else {
	    this.callParent(arguments);
	}
    },
});
