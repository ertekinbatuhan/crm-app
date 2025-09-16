# Design Assets

This folder contains the design files from Google Stitch for the CRM application redesign.

## Folder Structure

```
design_assets/
├── dashboard/
│   ├── dashboard.html    # HTML code from Google Stitch
│   └── dashboard.png      # Screenshot/preview of the dashboard design
├── contacts/
│   ├── contacts.html      # HTML code for contacts screen
│   └── contacts.png       # Contacts screen preview
├── deals/
│   ├── deals.html         # HTML code for deals screen
│   └── deals.png          # Deals screen preview
├── tasks/
│   ├── tasks.html         # HTML code for tasks screen
│   └── tasks.png          # Tasks screen preview
└── reports/
    ├── reports.html       # HTML code for reports screen
    └── reports.png        # Reports screen preview
```

## How to Add Your Design Files

1. Download the zip file from Google Stitch for each screen
2. Extract the contents
3. Place the HTML file and PNG image in the corresponding folder:
   - Dashboard design → `design_assets/dashboard/`
   - Contacts design → `design_assets/contacts/`
   - Deals design → `design_assets/deals/`
   - Tasks design → `design_assets/tasks/`
   - Reports design → `design_assets/reports/`

## File Naming Convention

Please rename your files to match this pattern:
- HTML files: `[screen_name].html` (e.g., `dashboard.html`)
- PNG files: `[screen_name].png` (e.g., `dashboard.png`)

## What These Files Are Used For

- **HTML files**: We'll analyze these to extract:
  - Color schemes and design tokens
  - Layout structures
  - Component patterns
  - Typography styles
  - Spacing and sizing

- **PNG files**: Visual reference for:
  - Overall design intent
  - Component appearance
  - Layout verification
  - Design system validation

Once all files are in place, we'll begin converting these designs into Flutter components and views.