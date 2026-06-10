import os, glob, sys

# 1. Patcher backwards_compatibility.rb
found = False
for path in glob.glob("vendor/bundle/**/*.rb", recursive=True):
    if "backwards_compatibility" in path and "open-sdg" in path:
        with open(path, "r") as f:
            content = f.read()
        old = "site.data['schema'].detect {|f| f['name'] == 'reporting_status' }"
        new = "site.data['schema'].detect {|f| f.is_a?(Hash) && f['name'] == 'reporting_status' }"
        if old in content:
            content = content.replace(old, new)
            with open(path, "w") as f:
                f.write(content)
            print(f"Patched: {path}")
            found = True
        else:
            # Afficher la ligne 37 pour debug
            lines = content.splitlines()
            print(f"Pattern not found in {path}")
            print(f"Line 37: {lines[36] if len(lines) > 36 else 'N/A'}")

if not found:
    print("WARNING: backwards_compatibility.rb not found or already patched")
    for p in glob.glob("vendor/bundle/**/*.rb", recursive=True):
        if "open-sdg" in p:
            print(f"  Found: {p}")

# 2. Écrire le bon schema.yml
schema = """- name: reporting_status
  field: reporting_status
  label: Reporting Status
  widget: select
- name: indicator_name
  field: indicator_name
  label: Indicator Name
  widget: text
- name: indicator_number
  field: indicator_number
  label: Indicator Number
  widget: text
- name: target_id
  field: target_id
  label: Target
  widget: text
- name: computation_units
  field: computation_units
  label: Unit of Measurement
  widget: text
- name: source_active_1
  field: source_active_1
  label: Source Active
  widget: boolean
- name: source_organisation_1
  field: source_organisation_1
  label: Source Organisation
  widget: text
"""

os.makedirs("_data", exist_ok=True)
with open("_data/schema.yml", "w") as f:
    f.write(schema)
print("schema.yml written")

# Écraser tous les schema.yml du thème remote
for path in glob.glob("vendor/bundle/**/*.yml", recursive=True):
    if "schema" in os.path.basename(path) and "open-sdg" in path:
        with open(path, "w") as f:
            f.write(schema)
        print(f"Overwritten: {path}")

print("Done.")
