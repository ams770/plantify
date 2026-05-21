part of '../home_view.dart';

class _HomeOptionBuilder extends StatelessWidget {
  const _HomeOptionBuilder({
    required this.title,
    required this.subTitle,
    required this.svg,
    required this.onTap,
  });

  final String title;
  final String subTitle;
  final String svg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.maxScreenWidth,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s30),
          color: ColorManager.white,
        ),
        child: Row(
          children: [
            /* ------------------------------- SVG Builder ------------------------------ */
            SvgPicture.asset(svg, height: AppSize.s120),
            SizedBox(width: AppSize.s10),
            /* ------------------------------ Title Builder ----------------------------- */
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  Text(
                    subTitle,

                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
