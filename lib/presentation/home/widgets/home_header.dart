part of '../home_view.dart';

class _HomeViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HomeViewHeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    var listTileTheme = Theme.of(context).listTileTheme;

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSize.s30),
        ),
      ),
      // Using ClipRRect prevents elements from drawing outside the curved bottom edge
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSize.s30),
        ),
        child: Stack(
          children: [
            // Moves up dynamically as shrinkOffset increases
            Positioned(
              top: kToolbarHeight - shrinkOffset,
              left: AppPadding.p20,
              right: AppPadding.p20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: AppSize.s55,
                    backgroundColor: ColorManager.white,
                    child: Image.asset(ImageAssets.logo, height: AppSize.s110),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppStrings.homeHeaderTitle.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      AppStrings.homeHeaderSubTitle.tr(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    titleTextStyle: listTileTheme.titleTextStyle?.copyWith(
                      color: ColorManager.white,
                    ),
                    subtitleTextStyle: listTileTheme.subtitleTextStyle
                        ?.copyWith(color: ColorManager.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 320;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
