# 🚀 FlowIt Quick Start Guide

A practical guide for developers working with the refactored FlowIt design system.

---

## 📦 What's New?

The FlowIt app now features a **modern design system** with:
- **AppTheme**: Centralized color palette and styles
- **AppConstants**: Standardized spacing, sizing, and durations
- **Component Library**: Reusable, pre-styled widgets
- **Responsive Layouts**: Adaptive designs for all screen sizes

---

## 🎨 Using Colors

### ✅ DO
```dart
import '../../core/theme/app_theme.dart';

Container(
  color: AppTheme.primaryBlue,        // Brand blue
  child: Text(
    'Hello',
    style: TextStyle(color: AppTheme.textOnPrimary),
  ),
)
```

### ❌ DON'T
```dart
Container(
  color: Color(0xFF1E5BFF),  // Hard-coded hex
  child: Text('Hello'),
)
```

### Color Reference

```dart
// Primary
AppTheme.primaryBlue          // #1E5BFF - Main brand color
AppTheme.accentBlue           // #56B8F4 - Secondary actions
AppTheme.accentBluePale       // #E8F5FF - Backgrounds

// Text
AppTheme.textPrimary          // Dark - Headings
AppTheme.textSecondary        // Medium - Body
AppTheme.textTertiary         // Light - Captions

// Status
AppTheme.success              // Green - Success states
AppTheme.warning              // Orange - Warnings
AppTheme.error                // Red - Errors
AppTheme.info                 // Blue - Info

// Surfaces
AppTheme.surfaceWhite         // #FFFFFF
AppTheme.surfaceGrey          // #F5F7F9
AppTheme.surfaceBlue          // #F0F7FF

// Borders
AppTheme.borderLight          // #E7EBF0 - Subtle
AppTheme.borderMedium         // #CDD7E1 - Default
```

---

## 📐 Using Spacing

### ✅ DO
```dart
import '../../core/theme/app_constants.dart';

Padding(
  padding: EdgeInsets.all(AppConstants.space16),
  child: Column(
    children: [
      Text('Title'),
      SizedBox(height: AppConstants.space12),
      Text('Body'),
    ],
  ),
)
```

### ❌ DON'T
```dart
Padding(
  padding: EdgeInsets.all(16),  // Magic number
  child: Column(
    children: [
      Text('Title'),
      SizedBox(height: 13),  // Random value
      Text('Body'),
    ],
  ),
)
```

### Spacing Reference

```dart
AppConstants.space4   = 4px    // Micro spacing
AppConstants.space8   = 8px    // Tight spacing
AppConstants.space12  = 12px   // Default small gap
AppConstants.space16  = 16px   // ⭐ Card padding (most common)
AppConstants.space20  = 20px   // Section spacing
AppConstants.space24  = 24px   // Large padding
AppConstants.space32  = 32px   // Section breaks
AppConstants.space48  = 48px   // Major sections
```

---

## 🃏 Using Cards

### Basic Card
```dart
import '../../core/widgets/frosted_card.dart';

FrostedCard(
  child: Column(
    children: [
      Text('Card Content'),
    ],
  ),
)
```

### Card with Elevation
```dart
FrostedCard(
  elevation: CardElevation.medium,  // ⭐ Default
  child: YourContent(),
)

// Options: none, low, medium, high, extraHigh
```

### Card Variants
```dart
// Compact (12px padding)
CompactFrostedCard(
  child: YourContent(),
)

// Large (24px padding)
LargeFrostedCard(
  child: YourContent(),
)

// Outlined (no blur, just border)
OutlinedCard(
  child: YourContent(),
)
```

---

## 📊 Using Metrics

### Basic Metric Tile
```dart
import '../../core/widgets/metric_tile.dart';

MetricTile(
  label: 'Flow Rate',
  value: '2.5',
  unit: 'L/min',
  icon: Icons.water_drop_outlined,
)
```

### With Trend Indicator
```dart
MetricTile(
  label: 'Temperature',
  value: '23.5',
  unit: '°C',
  icon: Icons.thermostat_outlined,
  trend: MetricTrend.up,      // up, down, neutral
  trendValue: '+2%',
)
```

### Compact Vertical Layout
```dart
CompactMetricTile(
  label: 'Session Usage',
  value: '1.2',
  unit: 'L',
  icon: Icons.local_drink_outlined,
)
```

### Metric Grid (Common Pattern)
```dart
GridView.count(
  crossAxisCount: 2,
  childAspectRatio: 2.25,
  mainAxisSpacing: AppConstants.space12,
  crossAxisSpacing: AppConstants.space12,
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  children: [
    MetricTile(label: 'Metric 1', value: '10', unit: 'L', icon: Icons.water),
    MetricTile(label: 'Metric 2', value: '20', unit: 'L', icon: Icons.speed),
    MetricTile(label: 'Metric 3', value: '30', unit: '°C', icon: Icons.thermostat),
    MetricTile(label: 'Metric 4', value: '40', unit: 'mL', icon: Icons.opacity),
  ],
)
```

---

## 📝 Using Section Headers

### Basic Header
```dart
import '../../core/widgets/section_header.dart';

SectionHeader(
  title: 'Live Metrics',
)
```

### With Subtitle
```dart
SectionHeader(
  title: 'System Status',
  subtitle: 'Real-time device monitoring',
)
```

### With Action Button
```dart
SectionHeaderWithAction(
  title: 'Recent Sessions',
  actionLabel: 'View All',
  onActionPressed: () {
    // Navigate or show more
  },
)
```

### With Badge Count
```dart
SectionHeaderWithBadge(
  title: 'Smart Alerts',
  count: 5,
)
```

### With Icon
```dart
SectionHeaderWithIcon(
  title: 'Settings',
  icon: Icons.settings_outlined,
)
```

---

## 🎯 Common Patterns

### Card with Header and Content
```dart
FrostedCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeader(title: 'Title'),
      SizedBox(height: AppConstants.space12),
      
      // Your content here
      Text('Content goes here'),
    ],
  ),
)
```

### Responsive Grid Layout
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < AppConstants.breakpointMobile;
    
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      children: items,
    );
  },
)
```

### Stacked Cards
```dart
Column(
  children: [
    FrostedCard(child: Content1()),
    SizedBox(height: AppConstants.space16),
    FrostedCard(child: Content2()),
    SizedBox(height: AppConstants.space16),
    FrostedCard(child: Content3()),
  ],
)
```

### Empty State
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.inbox_outlined,
        size: AppConstants.icon2xl,
        color: AppTheme.textTertiary,
      ),
      SizedBox(height: AppConstants.space16),
      Text(
        'No data yet',
        style: theme.textTheme.titleMedium,
      ),
      SizedBox(height: AppConstants.space8),
      Text(
        'Data will appear here when available',
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textTertiary,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  ),
)
```

---

## ✍️ Typography

### Text Styles
```dart
final theme = Theme.of(context);

// Large heading
Text(
  'Main Title',
  style: theme.textTheme.headlineSmall,  // 24px, w600
)

// Section header
Text(
  'Section',
  style: theme.textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.w700,
  ),  // 16px, w700
)

// Body text
Text(
  'Description',
  style: theme.textTheme.bodyMedium,  // 14px, w400
)

// Caption
Text(
  'Small text',
  style: theme.textTheme.bodySmall,  // 12px, w400
)
```

### Custom Text Colors
```dart
Text(
  'Important',
  style: theme.textTheme.bodyMedium?.copyWith(
    color: AppTheme.textPrimary,
    fontWeight: FontWeight.w600,
  ),
)
```

---

## 🎨 Border Radius

```dart
// Buttons, inputs
BorderRadius.circular(AppConstants.radiusMd)  // 12px

// Cards
BorderRadius.circular(AppConstants.radiusXl)  // 20px

// Pills, badges
BorderRadius.circular(AppConstants.radiusFull)  // 999px

// Small elements
BorderRadius.circular(AppConstants.radiusSm)  // 8px
```

---

## 🎭 Animations

### Standard Duration
```dart
AnimatedContainer(
  duration: AppConstants.durationNormal,  // 250ms
  curve: AppConstants.animationCurve,     // easeInOut
  // ...
)
```

### Duration Options
```dart
AppConstants.durationFast       // 150ms - Quick feedback
AppConstants.durationNormal     // 250ms - ⭐ Default
AppConstants.durationSlow       // 350ms - Emphasized
AppConstants.durationVerySlow   // 500ms - Dramatic
```

---

## 🎯 Buttons

### Filled Button (Primary)
```dart
FilledButton.icon(
  onPressed: () {},
  icon: Icon(Icons.save_outlined, size: AppConstants.iconSm),
  label: Text('Save'),
)
```

### Outlined Button (Secondary)
```dart
OutlinedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.cancel_outlined, size: AppConstants.iconSm),
  label: Text('Cancel'),
)
```

### Text Button (Tertiary)
```dart
TextButton(
  onPressed: () {},
  child: Text('Learn More'),
)
```

---

## 🔍 Icons

### Icon Sizes
```dart
Icon(Icons.home, size: AppConstants.iconSm)   // 20px
Icon(Icons.home, size: AppConstants.iconMd)   // 24px ⭐ Default
Icon(Icons.home, size: AppConstants.iconLg)   // 32px
Icon(Icons.home, size: AppConstants.iconXl)   // 40px
```

---

## 📱 Responsive Design

### Breakpoints
```dart
final screenWidth = MediaQuery.of(context).size.width;

if (screenWidth < AppConstants.breakpointMobile) {
  // Mobile: < 600px
  return _MobileLayout();
} else if (screenWidth < AppConstants.breakpointTablet) {
  // Tablet: 600-900px
  return _TabletLayout();
} else {
  // Desktop: > 900px
  return _DesktopLayout();
}
```

### Using LayoutBuilder
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final columns = constraints.maxWidth > 600 ? 4 : 2;
    return GridView.count(crossAxisCount: columns, children: items);
  },
)
```

---

## ⚠️ Common Mistakes

### ❌ DON'T
```dart
// Hard-coded colors
color: Color(0xFF1E5BFF)

// Magic numbers
padding: EdgeInsets.all(17)

// Random spacing
SizedBox(height: 13)

// Custom shadows every time
boxShadow: [BoxShadow(...)]

// Inconsistent radius
borderRadius: BorderRadius.circular(13.5)
```

### ✅ DO
```dart
// Use theme colors
color: AppTheme.primaryBlue

// Use constants
padding: EdgeInsets.all(AppConstants.space16)

// Use spacing grid
SizedBox(height: AppConstants.space12)

// Use elevation system
elevation: CardElevation.medium

// Use standard radius
borderRadius: BorderRadius.circular(AppConstants.radiusMd)
```

---

## 🎓 Learning Resources

1. **See Examples**: Check existing screens (Dashboard, Controls, Analytics, Connection)
2. **Read Components**: Browse `lib/core/widgets/` for component implementations
3. **Check Theme**: Review `lib/core/theme/app_theme.dart` for all colors
4. **View Constants**: See `lib/core/theme/app_constants.dart` for all values
5. **Read Guide**: Review `UI_REFACTORING_GUIDE.md` for comprehensive documentation

---

## 📋 Checklist for New Features

When creating new UI:

- [ ] Import `app_theme.dart` and `app_constants.dart`
- [ ] Use `AppTheme.*` for all colors
- [ ] Use `AppConstants.space*` for all spacing
- [ ] Use standard border radius values
- [ ] Use `FrostedCard` for containers
- [ ] Use `MetricTile` for metrics
- [ ] Use `SectionHeader` for section titles
- [ ] Use theme text styles
- [ ] Test on mobile AND desktop sizes
- [ ] Add animations with standard durations
- [ ] Ensure proper contrast ratios

---

## 🚀 Quick Reference

```dart
// Essential imports
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_constants.dart';
import '../../core/widgets/frosted_card.dart';
import '../../core/widgets/metric_tile.dart';
import '../../core/widgets/section_header.dart';

// Most common values
AppTheme.primaryBlue               // Brand color
AppTheme.textPrimary               // Heading text
AppTheme.textSecondary             // Body text
AppConstants.space16               // Card padding
AppConstants.space12               // Default gap
AppConstants.radiusXl              // Card radius (20px)
AppConstants.radiusMd              // Button radius (12px)
CardElevation.medium               // Default shadow
MetricTileSize.medium              // Default metric size
SectionHeaderSize.medium           // Default header size
```

---

## 💡 Pro Tips

1. **Use theme.textTheme**: Always access text styles through the theme
2. **Prefer components**: Use existing widgets instead of building from scratch
3. **Think responsive**: Consider mobile AND desktop from the start
4. **Follow the grid**: Stick to 8px spacing multiples
5. **Semantic colors**: Use status colors (success/warning/error) appropriately
6. **Consistent elevation**: Don't mix elevation levels randomly
7. **Test animations**: Verify durations feel natural
8. **Empty states**: Always handle no-data scenarios gracefully

---

## 🎯 Summary

**3 Steps to Success:**

1. **Import the design system**
   ```dart
   import '../../core/theme/app_theme.dart';
   import '../../core/theme/app_constants.dart';
   ```

2. **Use components instead of building from scratch**
   ```dart
   FrostedCard(child: ...)
   MetricTile(label: ..., value: ..., unit: ..., icon: ...)
   SectionHeader(title: ...)
   ```

3. **Follow the constants**
   ```dart
   color: AppTheme.primaryBlue
   padding: EdgeInsets.all(AppConstants.space16)
   borderRadius: BorderRadius.circular(AppConstants.radiusXl)
   ```

---

**You're ready to build beautiful, consistent UI! 🎉**

For detailed documentation, see `UI_REFACTORING_GUIDE.md`
