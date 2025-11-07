#!/bin/bash
# Build Automator Quick Action from md2pdf script

WORKFLOW_NAME="Convert Markdown to PDF"
WORKFLOW_DIR="QuickAction/${WORKFLOW_NAME}.workflow"
SCRIPT_FILE="scripts/md2pdf"

echo "🔨 Building Automator Quick Action..."
echo ""

# Check if md2pdf exists
if [ ! -f "$SCRIPT_FILE" ]; then
    echo "❌ Error: $SCRIPT_FILE not found"
    exit 1
fi

# Read the md2pdf content
SCRIPT_CONTENT=$(cat "$SCRIPT_FILE")

# XML-escape the script content
# Replace special XML characters
ESCAPED_SCRIPT=$(echo "$SCRIPT_CONTENT" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g')

# Remove existing workflow if present
if [ -d "$WORKFLOW_DIR" ]; then
    echo "🗑️  Removing existing workflow..."
    rm -rf "$WORKFLOW_DIR"
fi

# Create workflow directory structure
echo "📦 Creating workflow bundle structure..."
mkdir -p "$WORKFLOW_DIR/Contents/QuickLook"

# Create Info.plist
cat > "$WORKFLOW_DIR/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSBackgroundColorName</key>
			<string>background</string>
			<key>NSBackgroundSystemColorName</key>
			<string>systemBrownColor</string>
			<key>NSIconName</key>
			<string>NSTouchBarAllMyFiles</string>
			<key>NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>Convert Markdown to PDF</string>
			</dict>
			<key>NSMessage</key>
			<string>runWorkflowAsService</string>
			<key>NSRequiredContext</key>
			<dict>
				<key>NSApplicationIdentifier</key>
				<string>com.apple.finder</string>
			</dict>
			<key>NSSendFileTypes</key>
			<array>
				<string>public.item</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
EOF

# Create document.wflow with embedded script
cat > "$WORKFLOW_DIR/Contents/document.wflow" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AMApplicationBuild</key>
	<string>533</string>
	<key>AMApplicationVersion</key>
	<string>2.10</string>
	<key>AMDocumentVersion</key>
	<string>2</string>
	<key>actions</key>
	<array>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<false/>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.path</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.1.1</string>
				<key>AMApplication</key>
				<array>
					<string>Finder</string>
				</array>
				<key>AMParameterProperties</key>
				<dict>
					<key>itemType</key>
					<dict/>
					<key>predicate</key>
					<dict/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.path</string>
					</array>
				</dict>
				<key>AMRequiredResources</key>
				<array/>
				<key>AMSelectedInputType</key>
				<string>com.apple.cocoa.path</string>
				<key>AMSelectedOutputType</key>
				<string>com.apple.cocoa.path</string>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Filter Finder Items 2.action</string>
				<key>ActionName</key>
				<string>Filter Finder Items</string>
				<key>ActionParameters</key>
				<dict>
					<key>itemType</key>
					<string>com.apple.cocoa.path</string>
					<key>predicate</key>
					<data>
					YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25Z
					JGFyY2hpdmVyVCR0b3BYJG9iamVjdHMSAAGG
					oF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290
					gAGvEBoLDBMZISssLjU5Pj9CRkpPUFNaYGRp
					bG1vcVUkbnVsbNMNDg8QERJfEBdOU0NvbXBv
					dW5kUHJlZGljYXRlVHlwZV8QD05TU3VicHJl
					ZGljYXRlc1YkY2xhc3MQAYACgBnSFA8VGFpO
					Uy5vYmplY3RzohYXgAOAFIAY1A8aGxwdHh8g
					XxARTlNSaWdodEV4cHJlc3Npb25fEBBOU0xl
					ZnRFeHByZXNzaW9uXxATTlNQcmVkaWNhdGVP
					cGVyYXRvcoATgA6ABIAR1SIjJCUPJicoKSpZ
					TlNPcGVyYW5kXk5TU2VsZWN0b3JOYW1lXxAQ
					TlNFeHByZXNzaW9uVHlwZVtOU0FyZ3VtZW50
					c4AGgAUQA4AIgA1cdmFsdWVGb3JLZXk60iQP
					EC2AB9IvMDEyWiRjbGFzc25hbWVYJGNsYXNz
					ZXNfEBBOU1NlbGZFeHByZXNzaW9uozEzNFxO
					U0V4cHJlc3Npb25YTlNPYmplY3TSFA82OKE3
					gAmADNMPJDo7PD1ZTlNLZXlQYXRogAsQCoAK
					VG5hbWXSLzBAQV8QHE5TS2V5UGF0aFNwZWNp
					ZmllckV4cHJlc3Npb26jQDM00i8wQ0ReTlNN
					dXRhYmxlQXJyYXmjQ0U0V05TQXJyYXnSLzBH
					SF8QE05TS2V5UGF0aEV4cHJlc3Npb26kR0kz
					NF8QFE5TRnVuY3Rpb25FeHByZXNzaW9u00sk
					D0xNTl8QD05TQ29uc3RhbnRWYWx1ZYAPEACA
					EFMubWTSLzBRUl8QGU5TQ29uc3RhbnRWYWx1
					ZUV4cHJlc3Npb26jUTM01Q9UVVZXWE0oEFla
					TlNNb2RpZmllcldOU0ZsYWdzWk5TUG9zaXRp
					b25eTlNPcGVyYXRvclR5cGWAEhAJ0i8wW1xf
					EBxOU1N1YnN0cmluZ1ByZWRpY2F0ZU9wZXJh
					dG9ypF1eXzRfEBxOU1N1YnN0cmluZ1ByZWRp
					Y2F0ZU9wZXJhdG9yXxAZTlNTdHJpbmdQcmVk
					aWNhdGVPcGVyYXRvcl8QE05TUHJlZGljYXRl
					T3BlcmF0b3LSLzBhYl8QFU5TQ29tcGFyaXNv
					blByZWRpY2F0ZaNhYzRbTlNQcmVkaWNhdGXU
					DxobHB1mH2iAE4AVgASAF9NLJA9qTU6AFoAQ
					Uy5NRNUPVFVWV1hNKBBZgBLSLzBFcKJFNNIv
					MHJzXxATTlNDb21wb3VuZFByZWRpY2F0ZaNy
					YzQACAARABoAJAApADIANwBJAEwAUQBTAHAA
					dgB9AJcAqQCwALIAtAC2ALsAxgDJAMsAzQDP
					ANgA7AD/ARUBFwEZARsBHQEoATIBQQFUAWAB
					YgFkAWYBaAFqAXcBfAF+AYMBjgGXAaoBrgG7
					AcQByQHLAc0BzwHWAeAB4gHkAeYB6wHwAg8C
					EwIYAicCKwIzAjgCTgJTAmoCcQKDAoUChwKJ
					Ao0CkgKuArICvQLIAtAC2wLqAuwC7gLzAxID
					FwM2A1IDaANtA4UDiQOVA54DoAOiA6QDpgOt
					A68DsQO1A8ADwgPHA8oDzwPlAAAAAAAAAgEA
					AAAAAAAAdAAAAAAAAAAAAAAAAAAAA+k=
					</data>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.Automator.FilterFinderItems2</string>
				<key>CFBundleVersion</key>
				<string>2.1.1</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<false/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Category</key>
				<array>
					<string>AMCategoryFilesAndFolders</string>
				</array>
				<key>Class Name</key>
				<string>Filter_Finder_Items_2</string>
				<key>InputUUID</key>
				<string>3CD1169A-7BFD-424C-9D73-C2CA25266B3F</string>
				<key>Keywords</key>
				<array/>
				<key>OutputUUID</key>
				<string>EE7F10AD-ACCB-4460-97E0-2078C11B2FF2</string>
				<key>UUID</key>
				<string>6C3C2330-C7D3-4D26-BC2E-3FE381FBD877</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Finder</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<string>com.apple.cocoa.path</string>
						<key>name</key>
						<string>itemType</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
					<key>1</key>
					<dict>
						<key>default value</key>
						<data>
						</data>
						<key>name</key>
						<string>predicate</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>1</string>
					</dict>
				</dict>
				<key>conversionLabel</key>
				<integer>0</integer>
				<key>isViewVisible</key>
				<integer>1</integer>
				<key>location</key>
				<string>487.500000:328.000000</string>
				<key>nibPath</key>
				<string>/System/Library/Automator/Filter Finder Items 2.action/Contents/Resources/Base.lproj/main.nib</string>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<true/>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.0.3</string>
				<key>AMApplication</key>
				<array>
					<string>Automator</string>
				</array>
				<key>AMParameterProperties</key>
				<dict>
					<key>COMMAND_STRING</key>
					<dict/>
					<key>CheckedForUserDefaultShell</key>
					<dict/>
					<key>inputMethod</key>
					<dict/>
					<key>shell</key>
					<dict/>
					<key>source</key>
					<dict/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Run Shell Script.action</string>
				<key>ActionName</key>
				<string>Run Shell Script</string>
				<key>ActionParameters</key>
				<dict>
					<key>COMMAND_STRING</key>
					<string>$ESCAPED_SCRIPT</string>
					<key>CheckedForUserDefaultShell</key>
					<true/>
					<key>inputMethod</key>
					<integer>1</integer>
					<key>shell</key>
					<string>/bin/bash</string>
					<key>source</key>
					<string></string>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.RunShellScript</string>
				<key>CFBundleVersion</key>
				<string>2.0.3</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<false/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Category</key>
				<array>
					<string>AMCategoryUtilities</string>
				</array>
				<key>Class Name</key>
				<string>RunShellScriptAction</string>
				<key>InputUUID</key>
				<string>D17CF653-1A0D-4939-97C6-A39C834C5614</string>
				<key>Keywords</key>
				<array>
					<string>Shell</string>
					<string>Script</string>
					<string>Command</string>
					<string>Run</string>
					<string>Unix</string>
				</array>
				<key>OutputUUID</key>
				<string>19AB7692-7281-4745-9FC8-602FBD758869</string>
				<key>UUID</key>
				<string>AFB905D0-4FB8-4394-90BF-390197196888</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Automator</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>inputMethod</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
					<key>1</key>
					<dict>
						<key>default value</key>
						<false/>
						<key>name</key>
						<string>CheckedForUserDefaultShell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>1</string>
					</dict>
					<key>2</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>source</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>2</string>
					</dict>
					<key>3</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>COMMAND_STRING</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>3</string>
					</dict>
					<key>4</key>
					<dict>
						<key>default value</key>
						<string>/bin/sh</string>
						<key>name</key>
						<string>shell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>4</string>
					</dict>
				</dict>
				<key>isViewVisible</key>
				<integer>1</integer>
				<key>location</key>
				<string>487.500000:673.000000</string>
				<key>nibPath</key>
				<string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>connectors</key>
	<dict>
		<key>7786B52C-8990-4645-BB2D-A5224C2A948A</key>
		<dict>
			<key>from</key>
			<string>6C3C2330-C7D3-4D26-BC2E-3FE381FBD877 - 6C3C2330-C7D3-4D26-BC2E-3FE381FBD877</string>
			<key>to</key>
			<string>AFB905D0-4FB8-4394-90BF-390197196888 - AFB905D0-4FB8-4394-90BF-390197196888</string>
		</dict>
	</dict>
	<key>workflowMetaData</key>
	<dict>
		<key>applicationBundleID</key>
		<string>com.apple.finder</string>
		<key>applicationBundleIDsByPath</key>
		<dict>
			<key>/System/Library/CoreServices/Finder.app</key>
			<string>com.apple.finder</string>
		</dict>
		<key>applicationPath</key>
		<string>/System/Library/CoreServices/Finder.app</string>
		<key>applicationPaths</key>
		<array>
			<string>/System/Library/CoreServices/Finder.app</string>
		</array>
		<key>backgroundColor</key>
		<data>
		YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9i
		amVjdHMSAAGGoF8QD05TS2V5ZWRBcmNoaXZlctEICVRyb290gAGpCwwXGBkk
		KisyVSRudWxs1Q0ODxAREhMUFRZWJGNsYXNzW05TQ29sb3JOYW1lXE5TQ29s
		b3JTcGFjZV1OU0NhdGFsb2dOYW1lV05TQ29sb3KACIADEAaAAoAEVlN5c3Rl
		bV8QEHN5c3RlbUJyb3duQ29sb3LWDRobDxwdEh8gISIjXE5TQ29tcG9uZW50
		c1VOU1JHQl8QEk5TQ3VzdG9tQ29sb3JTcGFjZV8QEE5TTGluZWFyRXhwb3N1
		cmWACE0wLjYgMC40IDAuMiAxTxAnMC41MjU1MTg4OTQyIDAuMzI1NDM1MzQw
		NCAwLjE1MjE2MjE2NDQAEAGABUEx0yUmDScoKVROU0lEVU5TSUNDEAeABoAH
		TxEMSAAADEhMaW5vAhAAAG1udHJSR0IgWFlaIAfOAAIACQAGADEAAGFjc3BN
		U0ZUAAAAAElFQyBzUkdCAAAAAAAAAAAAAAAAAAD21gABAAAAANMtSFAgIAAA
		AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		EWNwcnQAAAFQAAAAM2Rlc2MAAAGEAAAAbHd0cHQAAAHwAAAAFGJrcHQAAAIE
		AAAAFHJYWVoAAAIYAAAAFGdYWVoAAAIsAAAAFGJYWVoAAAJAAAAAFGRtbmQA
		AAJUAAAAcGRtZGQAAALEAAAAiHZ1ZWQAAANMAAAAhnZpZXcAAAPUAAAAJGx1
		bWkAAAP4AAAAFG1lYXMAAAQMAAAAJHRlY2gAAAQwAAAADHJUUkMAAAQ8AAAI
		DGdUUkMAAAQ8AAAIDGJUUkMAAAQ8AAAIDHRleHQAAAAAQ29weXJpZ2h0IChj
		KSAxOTk4IEhld2xldHQtUGFja2FyZCBDb21wYW55AABkZXNjAAAAAAAAABJz
		UkdCIElFQzYxOTY2LTIuMQAAAAAAAAAAAAAAEnNSR0IgSUVDNjE5NjYtMi4x
		AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		AAAAAABYWVogAAAAAAAA81EAAQAAAAEWzFhZWiAAAAAAAAAAAAAAAAAAAAAA
		WFlaIAAAAAAAAG+iAAA49QAAA5BYWVogAAAAAAAAYpkAALeFAAAY2lhZWiAA
		AAAAAAAkoAAAD4QAALbPZGVzYwAAAAAAAAAWSUVDIGh0dHA6Ly93d3cuaWVj
		LmNoAAAAAAAAAAAAAAAWSUVDIGh0dHA6Ly93d3cuaWVjLmNoAAAAAAAAAAAA
		AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGRlc2MAAAAA
		AAAALklFQyA2MTk2Ni0yLjEgRGVmYXVsdCBSR0IgY29sb3VyIHNwYWNlIC0g
		c1JHQgAAAAAAAAAAAAAALklFQyA2MTk2Ni0yLjEgRGVmYXVsdCBSR0IgY29s
		b3VyIHNwYWNlIC0gc1JHQgAAAAAAAAAAAAAAAAAAAAAAAAAAAABkZXNjAAAA
		AAAAACxSZWZlcmVuY2UgVmlld2luZyBDb25kaXRpb24gaW4gSUVDNjE5NjYt
		Mi4xAAAAAAAAAAAAAAAsUmVmZXJlbmNlIFZpZXdpbmcgQ29uZGl0aW9uIGlu
		IElFQzYxOTY2LTIuMQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdmlldwAA
		AAAAE6T+ABRfLgAQzxQAA+3MAAQTCwADXJ4AAAABWFlaIAAAAAAATAlWAFAA
		AABXH+dtZWFzAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAACjwAAAAJzaWcg
		AAAAAENSVCBjdXJ2AAAAAAAABAAAAAAFAAoADwAUABkAHgAjACgALQAyADcA
		OwBAAEUASgBPAFQAWQBeAGMAaABtAHIAdwB8AIEAhgCLAJAAlQCaAJ8ApACp
		AK4AsgC3ALwAwQDGAMsA0ADVANsA4ADlAOsA8AD2APsBAQEHAQ0BEwEZAR8B
		JQErATIBOAE+AUUBTAFSAVkBYAFnAW4BdQF8AYMBiwGSAZoBoQGpAbEBuQHB
		AckB0QHZAeEB6QHyAfoCAwIMAhQCHQImAi8COAJBAksCVAJdAmcCcQJ6AoQC
		jgKYAqICrAK2AsECywLVAuAC6wL1AwADCwMWAyEDLQM4A0MDTwNaA2YDcgN+
		A4oDlgOiA64DugPHA9MD4APsA/kEBgQTBCAELQQ7BEgEVQRjBHEEfgSMBJoE
		qAS2BMQE0wThBPAE/gUNBRwFKwU6BUkFWAVnBXcFhgWWBaYFtQXFBdUF5QX2
		BgYGFgYnBjcGSAZZBmoGewaMBp0GrwbABtEG4wb1BwcHGQcrBz0HTwdhB3QH
		hgeZB6wHvwfSB+UH+AgLCB8IMghGCFoIbgiCCJYIqgi+CNII5wj7CRAJJQk6
		CU8JZAl5CY8JpAm6Cc8J5Qn7ChEKJwo9ClQKagqBCpgKrgrFCtwK8wsLCyIL
		OQtRC2kLgAuYC7ALyAvhC/kMEgwqDEMMXAx1DI4MpwzADNkM8w0NDSYNQA1a
		DXQNjg2pDcMN3g34DhMOLg5JDmQOfw6bDrYO0g7uDwkPJQ9BD14Peg+WD7MP
		zw/sEAkQJhBDEGEQfhCbELkQ1xD1ERMRMRFPEW0RjBGqEckR6BIHEiYSRRJk
		EoQSoxLDEuMTAxMjE0MTYxODE6QTxRPlFAYUJxRJFGoUixStFM4U8BUSFTQV
		VhV4FZsVvRXgFgMWJhZJFmwWjxayFtYW+hcdF0EXZReJF64X0hf3GBsYQBhl
		GIoYrxjVGPoZIBlFGWsZkRm3Gd0aBBoqGlEadxqeGsUa7BsUGzsbYxuKG7Ib
		2hwCHCocUhx7HKMczBz1HR4dRx1wHZkdwx3sHhYeQB5qHpQevh7pHxMfPh9p
		H5Qfvx/qIBUgQSBsIJggxCDwIRwhSCF1IaEhziH7IiciVSKCIq8i3SMKIzgj
		ZiOUI8Ij8CQfJE0kfCSrJNolCSU4JWgllyXHJfcmJyZXJocmtyboJxgnSSd6
		J6sn3CgNKD8ocSiiKNQpBik4KWspnSnQKgIqNSpoKpsqzysCKzYraSudK9Es
		BSw5LG4soizXLQwtQS12Last4S4WLkwugi63Lu4vJC9aL5Evxy/+MDUwbDCk
		MNsxEjFKMYIxujHyMioyYzKbMtQzDTNGM38zuDPxNCs0ZTSeNNg1EzVNNYc1
		wjX9Njc2cjauNuk3JDdgN5w31zgUOFA4jDjIOQU5Qjl/Obw5+To2OnQ6sjrv
		Oy07azuqO+g8JzxlPKQ84z0iPWE9oT3gPiA+YD6gPuA/IT9hP6I/4kAjQGRA
		pkDnQSlBakGsQe5CMEJyQrVC90M6Q31DwEQDREdEikTORRJFVUWaRd5GIkZn
		RqtG8Ec1R3tHwEgFSEtIkUjXSR1JY0mpSfBKN0p9SsRLDEtTS5pL4kwqTHJM
		uk0CTUpNk03cTiVObk63TwBPSU+TT91QJ1BxULtRBlFQUZtR5lIxUnxSx1MT
		U19TqlP2VEJUj1TbVShVdVXCVg9WXFapVvdXRFeSV+BYL1h9WMtZGllpWbha
		B1pWWqZa9VtFW5Vb5Vw1XIZc1l0nXXhdyV4aXmxevV8PX2Ffs2AFYFdgqmD8
		YU9homH1YklinGLwY0Njl2PrZEBklGTpZT1lkmXnZj1mkmboZz1nk2fpaD9o
		lmjsaUNpmmnxakhqn2r3a09rp2v/bFdsr20IbWBtuW4SbmtuxG8eb3hv0XAr
		cIZw4HE6cZVx8HJLcqZzAXNdc7h0FHRwdMx1KHWFdeF2Pnabdvh3VnezeBF4
		bnjMeSp5iXnnekZ6pXsEe2N7wnwhfIF84X1BfaF+AX5ifsJ/I3+Ef+WAR4Co
		gQqBa4HNgjCCkoL0g1eDuoQdhICE44VHhauGDoZyhteHO4efiASIaYjOiTOJ
		mYn+imSKyoswi5aL/IxjjMqNMY2Yjf+OZo7OjzaPnpAGkG6Q1pE/kaiSEZJ6
		kuOTTZO2lCCUipT0lV+VyZY0lp+XCpd1l+CYTJi4mSSZkJn8mmia1ZtCm6+c
		HJyJnPedZJ3SnkCerp8dn4uf+qBpoNihR6G2oiailqMGo3aj5qRWpMelOKWp
		phqmi6b9p26n4KhSqMSpN6mpqhyqj6sCq3Wr6axcrNCtRK24ri2uoa8Wr4uw
		ALB1sOqxYLHWskuywrM4s660JbSctRO1irYBtnm28Ldot+C4WbjRuUq5wro7
		urW7LrunvCG8m70VvY++Cr6Evv+/er/1wHDA7MFnwePCX8Lbw1jD1MRRxM7F
		S8XIxkbGw8dBx7/IPci8yTrJuco4yrfLNsu2zDXMtc01zbXONs62zzfPuNA5
		0LrRPNG+0j/SwdNE08bUSdTL1U7V0dZV1tjXXNfg2GTY6Nls2fHadtr724Dc
		BdyK3RDdlt4c3qLfKd+v4DbgveFE4cziU+Lb42Pj6+Rz5PzlhOYN5pbnH+ep
		6DLovOlG6dDqW+rl63Dr++yG7RHtnO4o7rTvQO/M8Fjw5fFy8f/yjPMZ86f0
		NPTC9VD13vZt9vv3ivgZ+Kj5OPnH+lf65/t3/Af8mP0p/br+S/7c/23//9Is
		LS4vWiRjbGFzc25hbWVYJGNsYXNzZXNcTlNDb2xvclNwYWNlojAxXE5TQ29s
		b3JTcGFjZVhOU09iamVjdNIsLTM0V05TQ29sb3KiMzEACAARABoAJAApADIA
		NwBJAEwAUQBTAF0AYwBuAHUAgQCOAJwApACmAKgAqgCsAK4AtQDIANUA4gDo
		AP0BEAESASABSgFMAU4BUAFXAVwBYgFkAWYBaA20DbkNxA3NDdoN3Q3qDfMN
		+A4AAAAAAAAAAgEAAAAAAAAANQAAAAAAAAAAAAAAAAAADgM=
		</data>
		<key>backgroundColorName</key>
		<string>systemBrownColor</string>
		<key>inputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>outputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>presentationMode</key>
		<integer>15</integer>
		<key>processesInput</key>
		<false/>
		<key>serviceApplicationBundleID</key>
		<string>com.apple.finder</string>
		<key>serviceApplicationPath</key>
		<string>/System/Library/CoreServices/Finder.app</string>
		<key>serviceInputTypeIdentifier</key>
		<string>com.apple.Automator.fileSystemObject</string>
		<key>serviceOutputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>serviceProcessesInput</key>
		<false/>
		<key>systemImageName</key>
		<string>NSTouchBarAllMyFiles</string>
		<key>useAutomaticInputType</key>
		<false/>
		<key>workflowTypeIdentifier</key>
		<string>com.apple.Automator.servicesMenu</string>
	</dict>
</dict>
</plist>
EOF

echo "✅ Workflow bundle created: $WORKFLOW_DIR"
echo ""
echo "📍 Installation:"
echo "   Double-click '$WORKFLOW_DIR' to install"
echo "   or"
echo "   cp -r '$WORKFLOW_DIR' ~/Library/Services/"
echo ""
echo "🧪 Testing:"
echo "   Right-click any .md file → Quick Actions → Convert Markdown to PDF"
echo ""
echo "🗑️  Uninstall:"
echo "   rm -rf ~/Library/Services/'$WORKFLOW_DIR'"
echo ""
echo "📦 The .workflow bundle can be distributed to users for easy installation!"
