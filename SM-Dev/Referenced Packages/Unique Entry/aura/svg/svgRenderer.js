({
  render: function(component, helper) {
    //grab attributes from the component markup
    var classname = component.get("v.class");
    var icontype = component.get("v.type");
      var iconname = component.get("v.name");
    var ariaHidden = component.get("v.ariaHidden");

    //return an svg element w/ the attributes
    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute('class', classname);
    svg.setAttribute('aria-hidden', ariaHidden);
    svg.innerHTML = '<use xlink:href="/resource/slds/' + icontype + '-sprite/svg/symbols.svg#' + iconname +'"></use>';
    return svg;
  }
})