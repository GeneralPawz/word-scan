namespace WordScanAddin
{
    internal static class RibbonXml
    {
        public const string Markup =
@"<customUI xmlns=""http://schemas.microsoft.com/office/2009/07/customui"">
  <ribbon>
    <tabs>
      <tab idMso=""TabHome"">
        <group id=""WordScanGroup"" label=""Scan"">
          <button id=""WordScanButton""
                  label=""Scan""
                  size=""large""
                  getImage=""GetButtonImage""
                  onAction=""OnScanClick""
                  screentip=""Scan""
                  supertip=""Scan a document with your system scanner and insert it at the cursor."" />
        </group>
      </tab>
    </tabs>
  </ribbon>
</customUI>";
    }
}
